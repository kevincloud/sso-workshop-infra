resource "aws_iam_policy" "this" {
  name        = "ssm_parameters_${var.application_name}_${var.environment_name}_read_policy"
  description = "Allows read operations on SSM parameters for the ${var.application_name} ${var.environment_name} environment."
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    Name        = "ssm_parameters_${var.application_name}_${var.environment_name}_${var.parameter_group_name}_read_policy"
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath"
    ]
    resources = [for parameter in aws_ssm_parameter.this : parameter.arn]
  }
}