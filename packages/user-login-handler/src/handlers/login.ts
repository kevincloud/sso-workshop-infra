import { GetParametersCommand, SSMClient } from "@aws-sdk/client-ssm"
import User, { Authorization, AuthorizationParams } from "@workshop-infrastructure/user-model"
import { RequestHandler } from "express"

const ssmClient = new SSMClient({})

const { AUDIENCE, ISSUER, RECIPIENT, CERTIFICATE, PRIVATE_KEY } = process.env
const audienceParameter = AUDIENCE ? AUDIENCE : "workshop-infrastructure/audience"
const issuerParameter = ISSUER ? ISSUER : "workshop-infrastructure/issuer"
const recipientParameter = RECIPIENT ? RECIPIENT : "workshop-infrastructure/recipient"
const certificateParameter = CERTIFICATE ? CERTIFICATE : "workshop-infrastructure/certificate"
const privateKeyParameter = PRIVATE_KEY ? PRIVATE_KEY : "workshop-infrastructure/private-key"

type GetAuthorizationParams = () => Promise<AuthorizationParams>
const getAuthorizationParams: GetAuthorizationParams = () => {
    const getParametersCommand = new GetParametersCommand({
        Names: [audienceParameter, issuerParameter, recipientParameter, certificateParameter, privateKeyParameter],
        WithDecryption: true,
    })
    return ssmClient.send(getParametersCommand).then(parameters => {
        const authorizationParams: AuthorizationParams = {
            audience: parameters.Parameters.find(parameter => parameter.Name === audienceParameter).Value,
            issuer: parameters.Parameters.find(parameter => parameter.Name === issuerParameter).Value,
            recipient: parameters.Parameters.find(parameter => parameter.Name === recipientParameter).Value,
            certificate: parameters.Parameters.find(parameter => parameter.Name === certificateParameter).Value,
            privateKey: parameters.Parameters.find(parameter => parameter.Name === privateKeyParameter).Value,
            sign: true,
        }
        return authorizationParams
    })
}

type AuthorizedResponse = (authorization: Authorization) => string
const authorizedResponse: AuthorizedResponse = authorization => `<html>
    <body>
        <form method="POST" action="${authorization.authorizationParams.recipient}">
            <h1>Logging in...</h1>
            <p>You will be redirect to the workshop environment in a moment</p><br />
            <input type="hidden" name="SAMLResponse" value="${authorization.authorization}" />
            <input type="submit" value="Login" />
            <hr />
            <em>If you are not redirected automatically, press the Login button above.</em>
        </form>
        <script>document.forms[0].submit()</script>
    </body>
</html>`

const authorizationParamsPromise = getAuthorizationParams()
const handler: RequestHandler = async (request, response) => {
    const projectId = request.query.id as string
    const signature = request.query.token as string
    const expiresAtTimestamp = Number.parseInt(request.query.expires as string)
    const expiresAt = expiresAtTimestamp ? new Date(expiresAtTimestamp) : undefined
    if (!projectId || !expiresAt || !signature) {
        response.status(400)
        response.end("invalid invitation: missing token")
        return
    }
    const user = await User.find(projectId)
    const verificationParams = { projectId, expiresAt, signature }
    const verification = user.verify(verificationParams)
    if (!verification.verified) {
        const invitation = Buffer.from(JSON.stringify(request.query)).toString("base64")
        response.status(400)
        response.end("invalid invitation: " + invitation)
        return
    }
    const authorizationParams = await authorizationParamsPromise
    const authorization = user.authorize(authorizationParams)
    response.type("html")
    response.end(authorizedResponse(authorization))
}

export default handler
