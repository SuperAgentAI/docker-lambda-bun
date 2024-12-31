provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      terraform = "true"
      scope     = var.application_name
    }
  }
}

resource "aws_ecr_repository" "lambda_runtime_bun" {
  name                 = "lambda/bun"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
