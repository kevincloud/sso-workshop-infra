import signUser from "./signature"
import { UserParams } from "./user"

export type Verification = {
    verified: boolean
    verificationParams: VerificationParams
}

export type VerificationParams = {
    projectId: string
    expiresAt: Date
    signature: string
}

type VerifyUser = (userParams: UserParams, verificationParams: VerificationParams) => Verification
const verifyUser: VerifyUser = (userParams, verificationParams) => {
    const { projectId, expiresAt, signature } = verificationParams
    if (projectId === userParams.projectId) {
        if (expiresAt.getTime() < Date.now()) {
            if (expiresAt.getTime() <= userParams.loginExpiresAt.getTime()) {
                const signatureParameters = { expiresAt }
                const expectedSignature = signUser(userParams, signatureParameters)
                return {
                    verified: expectedSignature.signature === signature,
                    verificationParams,
                }
            }
        }
    }
    return {
        verified: false,
        verificationParams,
    }
}

export default verifyUser
