resource "aws_lambda_function" "this" {
  function_name    = "${var.application_name}-${var.environment_name}-${var.function_name}"
  filename         = var.function_source
  source_code_hash = filebase64sha256(var.function_source)

  role        = aws_iam_role.this.arn
  handler     = var.function_handler
  runtime     = var.function_runtime
  memory_size = var.function_memory

  environment {
    variables = var.environment_variables
  }

  tags = {
    Name        = var.function_name
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.application_name}-${var.environment_name}-${var.function_name}"
  assume_role_policy = data.aws_iam_policy_document.this_lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = merge(var.policy_attachments, { cloudwatch_logs_writer : aws_iam_policy.this_cloudwatch_logs_writer.arn })
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

data "aws_iam_policy_document" "this_lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}