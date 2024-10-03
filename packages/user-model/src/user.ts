import authorizeUser, { Authorization, AuthorizationParams } from "./authorization"
import { deleteUser, findUser, saveUser } from "./repository"
import signUser, { Signature, SignatureParams } from "./signature"
import verifyUser, { Verification, VerificationParams } from "./verification"

export type UserParams = {
    projectId: string
    projectKey: string
    projectName: string
    loginEmail: string
    loginSecret: string
    loginExpiresAt: Date
    studentEmail: string
    studentOrganizationKey: string
}

export default class User implements UserParams {
    projectId: string
    projectKey: string
    projectName: string
    loginEmail: string
    loginSecret: string
    loginExpiresAt: Date
    studentEmail: string
    studentOrganizationKey: string

    constructor(userParams: UserParams) {
        this.projectId = userParams.projectId
        this.projectKey = userParams.projectKey
        this.projectName = userParams.projectName
        this.loginEmail = userParams.loginEmail
        this.loginSecret = userParams.loginSecret
        this.loginExpiresAt = userParams.loginExpiresAt
        this.studentEmail = userParams.studentEmail
        this.studentOrganizationKey = userParams.studentOrganizationKey
    }

    authorize(authorizationParams: AuthorizationParams): Authorization {
        return authorizeUser(this as UserParams, authorizationParams)
    }

    sign(signatureParams: SignatureParams): Signature {
        return signUser(this as UserParams, signatureParams)
    }

    verify(verificationParams: VerificationParams): Verification {
        return verifyUser(this as UserParams, verificationParams)
    }

    async delete() {
        return await deleteUser(this as UserParams)
    }

    async save() {
        return await saveUser(this as UserParams)
    }

    static async find(projectId: string): Promise<User> {
        const userParams = await findUser(projectId)
        return new User(userParams)
    }
}
