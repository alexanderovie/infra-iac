# AWS Core provider module for Fascinante Digital
# Provides generic S3 buckets, SQS queues, and basic IAM roles

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generic S3 buckets
resource "aws_s3_bucket" "generic_buckets" {
  for_each = var.s3_buckets

  bucket = each.value.bucket_name

  tags = merge(each.value.tags, {
    Name        = each.value.bucket_name
    Environment = var.environment
    Project     = "Fascinante Digital"
    ManagedBy   = "Terraform"
  })
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "generic_buckets" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.generic_buckets[each.key].id
  versioning_configuration {
    status = each.value.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# S3 bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "generic_buckets" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.generic_buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = each.value.encryption_algorithm
    }
    bucket_key_enabled = each.value.bucket_key_enabled
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "generic_buckets" {
  for_each = var.s3_buckets

  bucket = aws_s3_bucket.generic_buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SQS queues
resource "aws_sqs_queue" "generic_queues" {
  for_each = var.sqs_queues

  name                       = each.value.queue_name
  delay_seconds              = each.value.delay_seconds
  max_message_size           = each.value.max_message_size
  message_retention_seconds  = each.value.message_retention_seconds
  receive_wait_time_seconds  = each.value.receive_wait_time_seconds
  visibility_timeout_seconds = each.value.visibility_timeout_seconds

  tags = merge(each.value.tags, {
    Name        = each.value.queue_name
    Environment = var.environment
    Project     = "Fascinante Digital"
    ManagedBy   = "Terraform"
  })
}

# Dead letter queues (if configured)
resource "aws_sqs_queue" "dead_letter_queues" {
  for_each = {
    for k, v in var.sqs_queues : k => v
    if v.dead_letter_queue != null
  }

  name = "${each.value.queue_name}-dlq"

  tags = merge(each.value.tags, {
    Name        = "${each.value.queue_name}-dlq"
    Environment = var.environment
    Project     = "Fascinante Digital"
    ManagedBy   = "Terraform"
  })
}

# Dead letter queue policies
resource "aws_sqs_queue_redrive_policy" "dead_letter_queues" {
  for_each = {
    for k, v in var.sqs_queues : k => v
    if v.dead_letter_queue != null
  }

  queue_url = aws_sqs_queue.generic_queues[each.key].id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queues[each.key].arn
    maxReceiveCount     = each.value.dead_letter_queue.max_receive_count
  })
}

# Basic IAM roles (placeholders)
resource "aws_iam_role" "basic_roles" {
  for_each = var.iam_roles

  name = each.value.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = each.value.assume_role_service
        }
      }
    ]
  })

  tags = merge(each.value.tags, {
    Name        = each.value.role_name
    Environment = var.environment
    Project     = "Fascinante Digital"
    ManagedBy   = "Terraform"
  })
}

# IAM role policies
resource "aws_iam_role_policy" "basic_roles" {
  for_each = var.iam_roles

  name = "${each.value.role_name}-policy"
  role = aws_iam_role.basic_roles[each.key].id

  policy = each.value.policy_document
}
