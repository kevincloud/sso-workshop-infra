resource "aws_apigatewayv2_api" "this" {
  name          = "${var.application_name}-${var.environment_name}-${var.api_name}"
  protocol_type = "HTTP"

  tags = {
    Name        = var.api_name
    Application = var.application_name
    Environment = var.environment_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_apigatewayv2_deployment" "this" {
  api_id = aws_apigatewayv2_api.this.id
}

resource "aws_apigatewayv2_stage" "this" {
  api_id        = aws_apigatewayv2_api.this.id
  deployment_id = aws_apigatewayv2_deployment.this.id
  name          = var.environment_name

  tags = {
    Name        = var.api_name
    Application = var.application_name
    Environment = var.environment_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.api_route_mappings

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = each.value
  payload_format_version = "2.0"
  description            = "${each.value} lambda function integration."
  passthrough_behavior   = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.api_route_mappings

  api_id    = aws_apigatewayv2_integration.this[each.key].api_id
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
  route_key = each.key
}