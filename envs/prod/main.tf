# Production environment configuration
# This file configures the production environment for Fascinante Digital

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5"
    }
  }

  backend "s3" {
    # This will be configured via backend.hcl
  }
}

# Cloudflare module
module "cloudflare" {
  source = "../../providers/cloudflare"

  cloudflare_api_token = var.cloudflare_api_token
  domain               = var.domain
  environment          = "prod"

  a_records = {
    "@" = {
      value   = var.main_ip
      proxied = true
      comment = "Main domain A record (prod)"
    }
    "www" = {
      value   = var.main_ip
      proxied = true
      comment = "WWW subdomain (prod)"
    }
  }

  cname_records = {
    "api" = {
      value   = "api.fascinantedigital.com"
      proxied = false
      comment = "Production API subdomain"
    }
    "cdn" = {
      value   = "cdn.fascinantedigital.com"
      proxied = true
      comment = "CDN subdomain"
    }
  }

  txt_records = {
    "@" = {
      value   = "v=spf1 include:_spf.google.com ~all"
      comment = "SPF record for email"
    }
  }

  mx_records = {
    "@" = {
      value    = "aspmx.l.google.com"
      priority = 1
      comment  = "Google Workspace MX"
    }
    "@" = {
      value    = "alt1.aspmx.l.google.com"
      priority = 5
      comment  = "Google Workspace MX Alt 1"
    }
    "@" = {
      value    = "alt2.aspmx.l.google.com"
      priority = 5
      comment  = "Google Workspace MX Alt 2"
    }
  }
}

# AWS SES module
module "ses" {
  source = "../../providers/aws-ses"

  domain      = var.domain
  environment = "prod"
  aws_region  = var.aws_region

  # Configure MAIL FROM for better email deliverability
  mail_from_subdomain = "mail"
  route53_zone_id     = var.route53_zone_id
}

# AWS Core module
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = var.aws_region

  s3_buckets = {
    "prod-assets" = {
      bucket_name          = "fascinante-prod-assets"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Production assets"
        Type    = "Static files"
      }
    }
    "prod-backups" = {
      bucket_name          = "fascinante-prod-backups"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Production backups"
        Type    = "Backup storage"
      }
    }
    "prod-logs" = {
      bucket_name          = "fascinante-prod-logs"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Production logs"
        Type    = "Log storage"
      }
    }
  }

  sqs_queues = {
    "prod-email-queue" = {
      queue_name                 = "fascinante-prod-email-queue"
      delay_seconds              = 0
      max_message_size           = 262144
      message_retention_seconds  = 1209600
      visibility_timeout_seconds = 30
      dead_letter_queue = {
        max_receive_count = 3
      }
      tags = {
        Purpose = "Production email processing"
        Type    = "Message queue"
      }
    }
    "prod-notification-queue" = {
      queue_name                 = "fascinante-prod-notification-queue"
      delay_seconds              = 0
      max_message_size           = 262144
      message_retention_seconds  = 1209600
      visibility_timeout_seconds = 30
      dead_letter_queue = {
        max_receive_count = 3
      }
      tags = {
        Purpose = "Production notifications"
        Type    = "Message queue"
      }
    }
  }

  iam_roles = {
    "lambda-execution" = {
      role_name           = "fascinante-prod-lambda-execution"
      assume_role_service = "lambda.amazonaws.com"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "arn:aws:logs:*:*:*"
          },
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject"
            ]
            Resource = "arn:aws:s3:::fascinante-prod-*/*"
          },
          {
            Effect = "Allow"
            Action = [
              "sqs:SendMessage",
              "sqs:ReceiveMessage",
              "sqs:DeleteMessage"
            ]
            Resource = "arn:aws:sqs:*:*:fascinante-prod-*"
          }
        ]
      })
      tags = {
        Purpose = "Lambda execution"
        Type    = "Service role"
      }
    }
  }
}
