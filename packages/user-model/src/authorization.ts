import { utc } from "moment"
import { v4 } from "uuid"
import { Saml20 } from "saml"

import { UserParams } from "./user"

export type Authorization = {
    authorization: string
    authorizationParams: AuthorizationParams
}

export type AuthorizationParams = {
    audience: string
    issuer: string
    recipient: string
    sign: boolean
    certificate?: string
    privateKey?: string
}

type AuthorizeUser = (userParams: UserParams, authorizationParams: AuthorizationParams) => Authorization
const authorizeUser: AuthorizeUser = (userParams, authorizationParams) => {
    if (authorizationParams.sign) {
        if (!authorizationParams.certificate) throw new Error("certificate is required to sign authorization")
        if (!authorizationParams.privateKey) throw new Error("private key is required to sign authorization")
    }
    const samlOptions = {
        cert: authorizationParams.certificate ? Buffer.from(authorizationParams.certificate) : undefined,
        key: authorizationParams.privateKey ? Buffer.from(authorizationParams.privateKey) : undefined,
        attributes: {
            "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress": userParams.loginEmail,
        },
        audiences: authorizationParams.audience,
        authnContextClassRef: "urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified",
        issuer: authorizationParams.issuer,
        lifetimeInSeconds: 600,
        nameIdentifier: userParams.loginEmail,
        nameIdentifierFormat: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress",
        recipient: authorizationParams.recipient,
        subjectConfirmationMethod: "urn:oasis:names:tc:SAML:2.0:cm:bearer",
        sessionIndex: "_" + v4(),
    }
    const responseId = "_" + v4()
    const samlAssertion = authorizationParams.sign
        ? Saml20.create(samlOptions)
        : Saml20.createUnsignedAssertion(samlOptions)
    const issueInstant = utc().format("YYYY-MM-DDTHH:mm:ss.SSS[Z]")
    const samlResponse = `<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" Version="2.0" ID="${responseId}" IssueInstant="${issueInstant}" Destination="${authorizationParams.recipient}">
    <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">${authorizationParams.issuer}</saml:Issuer>
    <samlp:Status>
      <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
    </samlp:Status>
    ${samlAssertion}
</samlp:Response>`
    const authorization = Buffer.from(samlResponse).toString("base64")
    return {
        authorization,
        authorizationParams,
    }
}

export default authorizeUser
