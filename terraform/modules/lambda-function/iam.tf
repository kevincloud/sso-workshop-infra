resource "aws_iam_policy" "this" {
  name        = "lambda_${aws_lambda_function.this.function_name}_invoke_policy"
  description = "Allows invocation of the ${aws_lambda_function.this.function_name} lambda function."
  policy      = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:Invoke"
    ]
    resources = [
      aws_lambda_function.this.arn
    ]
  }
}