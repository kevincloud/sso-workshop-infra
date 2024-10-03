resource "aws_dynamodb_table" "this" {
  name         = "${var.application_name}-${var.environment_name}-${var.table_name}"
  hash_key     = var.hash_key
  billing_mode = "PAY_PER_REQUEST"

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.key
      type = attribute.value
    }
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment_name
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}