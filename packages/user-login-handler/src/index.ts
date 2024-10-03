import ServerlessExpress from "@vendia/serverless-express"
import express from "express"

import { login } from "./handlers"

const app = express()
app.get("/login", login)

exports.handler = ServerlessExpress({ app })
