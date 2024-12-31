terraform {
  backend "s3" {
    bucket         = "terraform-state-superagent"
    key            = "525999333867/us-west-1/superagent/global/lambda/bun/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks-superagent"
  }
}
