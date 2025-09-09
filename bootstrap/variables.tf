variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "fascinante-digital-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "fascinante-digital-terraform-locks"
}
