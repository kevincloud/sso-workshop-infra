module "user_created_handler_function" {
  source = "./modules/lambda-function"

  application_name = var.application_name
  environment_name = var.environment_name
  maintainer_email = var.maintainer_email

  function_source  = "../packages/user-created-handler/dist/main.js.zip"
  function_name    = "user-created-handler"
  function_handler = "main.handler"
  function_runtime = "nodejs16.x"
  function_memory  = "256"

  environment_variables = {
    USERS_TABLE_NAME = module.ssm_parameters.parameter_names[var.users_table_name_parameter_name]
  }

  policy_attachments = {
    ssm_parameters_reader = module.ssm_parameters.parameter_read_policy_arn
    users_table_reader    = module.users_dynamodb_table.table_read_policy_arn
    users_table_writer    = module.users_dynamodb_table.table_write_policy_arn
  }
}

module "user_login_handler_function" {
  source = "./modules/lambda-function"

  application_name = var.application_name
  environment_name = var.environment_name
  maintainer_email = var.maintainer_email

  function_source  = "../packages/user-login-handler/dist/main.js.zip"
  function_name    = "user-login-handler"
  function_handler = "main.handler"
  function_runtime = "nodejs16.x"
  function_memory  = "256"

  environment_variables = {
    AUDIENCE         = module.ssm_parameters.parameter_names[var.saml_audience_parameter_name]
    ISSUER           = module.ssm_parameters.parameter_names[var.saml_issuer_parameter_name]
    RECIPIENT        = module.ssm_parameters.parameter_names[var.saml_recipient_parameter_name]
    CERTIFICATE      = module.ssm_parameters.parameter_names[var.saml_certificate_parameter_name]
    PRIVATE_KEY      = module.ssm_parameters.parameter_names[var.saml_private_key_parameter_name]
    USERS_TABLE_NAME = module.ssm_parameters.parameter_names[var.users_table_name_parameter_name]
  }

  policy_attachments = {
    ssm_parameters_reader = module.ssm_parameters.parameter_read_policy_arn
    users_table_reader    = module.users_dynamodb_table.table_read_policy_arn
    users_table_writer    = module.users_dynamodb_table.table_write_policy_arn
  }
}