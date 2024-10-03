output "api_id" {
  description = "The identifier of the API Gateway created by this module."
  value = aws_apigatewayv2_api.this.id
}

output "api_arn" {
  description = "The ARN of the API Gateway created by this module."
  value = aws_apigatewayv2_api.this.arn
}

output "api_url" {
  description = "The invoke URL of the API Gateway created by this module."
  value = aws_apigatewayv2_stage.this.invoke_url
}