module "api_gateway" {
  source = "./modules/api-gateway"

  application_name = var.application_name
  environment_name = var.environment_name
  maintainer_email = var.maintainer_email
  api_name         = "api"

  api_route_mappings = {
    "ANY /{proxy+}" : module.user_login_handler_function.function_invoke_arn
  }
}