resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 30

  tags = {
    Name        = "/aws/lambda/${aws_lambda_function.this.function_name}"
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_iam_policy" "this_cloudwatch_logs_writer" {
  name        = "cloudwatch_logs_${aws_lambda_function.this.function_name}_write_policy"
  description = "Allows write operations on the ${aws_cloudwatch_log_group.this.name} log group."
  policy      = data.aws_iam_policy_document.this_cloudwatch_logs_writer.json
}

data "aws_iam_policy_document" "this_cloudwatch_logs_writer" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      aws_cloudwatch_log_group.this.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}