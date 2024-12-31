variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}

variable "application_name" {
  description = "name of the containing service or application"
  type        = string
  default     = "bun"
}
