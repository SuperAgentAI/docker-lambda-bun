provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Scope       = "superagent"
      Environment = "common"
      Repository  = "docker-lambda-bun"
      Owner       = "terraform:infrastructure"
      Terraform   = "true"
    }
  }
}

resource "aws_ecr_repository" "lambda_runtime_bun" {
  name                 = "lambda/bun"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
