variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "s3_buckets" {
  description = "Map of S3 buckets to create"
  type = map(object({
    bucket_name          = string
    versioning_enabled   = optional(bool, true)
    encryption_algorithm = optional(string, "AES256")
    bucket_key_enabled   = optional(bool, false)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

variable "sqs_queues" {
  description = "Map of SQS queues to create"
  type = map(object({
    queue_name                 = string
    delay_seconds              = optional(number, 0)
    max_message_size           = optional(number, 262144)
    message_retention_seconds  = optional(number, 1209600)
    receive_wait_time_seconds  = optional(number, 0)
    visibility_timeout_seconds = optional(number, 30)
    dead_letter_queue = optional(object({
      max_receive_count = number
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "iam_roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    role_name           = string
    assume_role_service = string
    policy_document     = string
    tags                = optional(map(string), {})
  }))
  default = {}
}
