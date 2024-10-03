terraform {
  backend "s3" {
    bucket         = "workshop-infrastructure-state"
    key            = "terraform.tfstate"
    dynamodb_table = "workshop-infrastructure-state"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.3"
    }
  }
  required_version = "~> 1.3.0"
}

provider "aws" {}
provider "tls" {}

resource "aws_s3_bucket" "this" {
  bucket = "workshop-infrastructure-state"

  tags = {
    Name        = "state"
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name         = "workshop-infrastructure-state"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "state"
    Application = var.application_name
    Maintainer  = var.maintainer_email
    CreatedBy   = "terraform"
  }
}
