module "users_dynamodb_table" {
  source = "./modules/dynamodb-table"

  application_name = var.application_name
  environment_name = var.environment_name
  maintainer_email = var.maintainer_email
  table_name       = "users"
  hash_key         = "ProjectId"

  attributes = {
    ProjectId = "S"
  }
}