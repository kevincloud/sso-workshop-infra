import { createHmac } from "crypto"

import { UserParams } from "./user"

export type Signature = {
    signature: string
    signatureParams: SignatureParams
}

export type SignatureParams = {
    expiresAt: Date
}

type SignUser = (userParams: UserParams, signatureParams: SignatureParams) => Signature
const signUser: SignUser = (userParams, signatureParams) => {
    const { expiresAt } = signatureParams
    const data = `${userParams.projectId}.${expiresAt.getTime()}`
    const signature = createHmac("sha256", userParams.loginSecret).update(data).digest("hex")
    return { signature, signatureParams }
}

export default signUser
