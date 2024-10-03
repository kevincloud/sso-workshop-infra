output "table_arn" {
  description = "The ARN of the table."
  value = aws_dynamodb_table.this.arn
}

output "table_name" {
  description = "The name of the table."
  value = aws_dynamodb_table.this.name
}

output "table_read_policy_arn" {
  description = "The ARN of the IAM policy that grants read access to the table."
  value = aws_iam_policy.this_read.arn
}

output "table_write_policy_arn" {
  description = "The ARN of the IAM policy that grants write access to the table."
  value = aws_iam_policy.this_write.arn
}