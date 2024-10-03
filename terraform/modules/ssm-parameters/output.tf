output "parameter_names" {
  description = "The parameter names, indexed by short name."
  value = { for name, parameter in local.parameters : name => parameter.name }
}

output "parameter_arns" {
  description = "The parameter ARNs, indexed by short name."
  value = { for parameter in aws_ssm_parameter.this : parameter.tags.Name => parameter.arn }
}

output "parameter_read_policy_arn" {
  description = "The ARN of the IAM policy that grants read access to the parameters."
  value = aws_iam_policy.this.arn
}