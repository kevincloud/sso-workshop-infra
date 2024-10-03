import {
    DeleteItemCommand,
    DeleteItemCommandOutput,
    DynamoDBClient,
    GetItemCommand,
    PutItemCommand,
    PutItemCommandOutput,
} from "@aws-sdk/client-dynamodb"
import { GetParameterCommand, SSMClient } from "@aws-sdk/client-ssm"

import { UserParams } from "./user"

const dynamodbClient = new DynamoDBClient({})
const ssmClient = new SSMClient({})

const { USERS_TABLE_NAME } = process.env
const tableNameParameter = USERS_TABLE_NAME ? USERS_TABLE_NAME : "workshop-infrastructure/users-table-name"

type GetTableName = () => Promise<string>
const getTableName: GetTableName = () => {
    const getParameterCommand = new GetParameterCommand({
        Name: tableNameParameter,
        WithDecryption: true,
    })
    return ssmClient.send(getParameterCommand).then(parameter => {
        return parameter.Parameter.Value
    })
}

const tableNamePromise = getTableName()

type DeleteUser = (userParams: UserParams) => Promise<DeleteItemCommandOutput>
const deleteUser: DeleteUser = async userParams => {
    const tableName = await tableNamePromise
    const deleteItemCommand = new DeleteItemCommand({
        TableName: tableName,
        Key: {
            ProjectId: {
                S: userParams.projectId,
            },
        },
    })
    return await dynamodbClient.send(deleteItemCommand)
}

type FindUser = (projectId: string) => Promise<UserParams>
const findUser: FindUser = async projectId => {
    const tableName = await tableNamePromise
    const getItemCommand = new GetItemCommand({
        TableName: tableName,
        Key: {
            ProjectId: {
                S: projectId,
            },
        },
    })
    const { Item: userItem } = await dynamodbClient.send(getItemCommand)
    return {
        projectId: userItem.ProjectId.S,
        projectKey: userItem.ProjectKey.S,
        projectName: userItem.ProjectName.S,
        loginEmail: userItem.LoginEmail.S,
        loginSecret: userItem.LoginSecret.S,
        loginExpiresAt: new Date(Number.parseInt(userItem.LoginExpiresAt.N)),
        studentEmail: userItem.StudentEmail.S,
        studentOrganizationKey: userItem.StudentOrganizationKey.S,
    }
}

type SaveUser = (userParams: UserParams) => Promise<PutItemCommandOutput>
const saveUser: SaveUser = async userParams => {
    const tableName = await tableNamePromise
    const putItemCommand = new PutItemCommand({
        TableName: tableName,
        Item: {
            ProjectId: {
                S: userParams.projectId,
            },
            ProjectKey: {
                S: userParams.projectKey,
            },
            ProjectName: {
                S: userParams.projectName,
            },
            LoginEmail: {
                S: userParams.loginEmail,
            },
            LoginSecret: {
                S: userParams.loginSecret,
            },
            LoginExpiresAt: {
                N: userParams.loginExpiresAt.getTime().toString(),
            },
            StudentEmail: {
                S: userParams.studentEmail,
            },
            StudentOrganizationKey: {
                S: userParams.studentOrganizationKey,
            },
        },
    })
    return await dynamodbClient.send(putItemCommand)
}

export { findUser, deleteUser, saveUser }
