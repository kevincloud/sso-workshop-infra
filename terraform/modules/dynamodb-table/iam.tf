resource "aws_iam_policy" "this_read" {
  name        = "dynamodb_${aws_dynamodb_table.this.name}_read_policy"
  description = "Allows read operations on the ${aws_dynamodb_table.this.name} DynamoDB table."
  policy      = data.aws_iam_policy_document.users_table_read.json

  tags = {
    Name        = "dynamodb_${aws_dynamodb_table.this.name}_read_policy"
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_iam_policy" "this_write" {
  name        = "dynamodb_${aws_dynamodb_table.this.name}_write_policy"
  description = "Allows write operations on the ${aws_dynamodb_table.this.name} DynamoDB table."
  policy      = data.aws_iam_policy_document.users_table_write.json

  tags = {
    Name        = "dynamodb_${aws_dynamodb_table.this.name}_write_policy"
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

data "aws_iam_policy_document" "users_table_read" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:ListTagsOfResource",
      "dynamodb:PartiQLSelect",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.this.arn
    ]
  }
}

data "aws_iam_policy_document" "users_table_write" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:PartiQLDelete",
      "dynamodb:PartiQLInsert",
      "dynamodb:PartiQLUpdate",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      aws_dynamodb_table.this.arn
    ]
  }
}