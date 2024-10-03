resource "aws_ssm_parameter" "this" {
  for_each = local.parameters

  name  = each.value.name
  type  = each.value.type
  value = each.value.value

  tags = {
    Name        = each.key
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}