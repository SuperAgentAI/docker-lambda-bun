terraform {
  backend "s3" {
    bucket         = "terraform-state-superagent"
    dynamodb_table = "terraform-locks-superagent"
    key            = "525999333867/common/docker-lambda-bun/terraform.tfstate"
    region         = "us-west-1"
  }
}
