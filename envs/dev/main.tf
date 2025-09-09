# Development environment configuration
# This file configures the development environment for Fascinante Digital

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
  environment          = "dev"

  a_records = {
    "@" = {
      value   = var.main_ip
      proxied = true
      comment = "Main domain A record (dev)"
    }
    "www" = {
      value   = var.main_ip
      proxied = true
      comment = "WWW subdomain (dev)"
    }
    "dev" = {
      value   = var.dev_ip
      proxied = true
      comment = "Development subdomain"
    }
  }

  cname_records = {
    "api-dev" = {
      value   = "api-dev.fascinantedigital.com"
      proxied = false
      comment = "Development API subdomain"
    }
  }

  txt_records = {
    "@" = {
      value   = "v=spf1 include:_spf.google.com ~all"
      comment = "SPF record for email"
    }
  }
}

# AWS SES module
module "ses" {
  source = "../../providers/aws-ses"

  domain      = var.domain
  environment = "dev"
  aws_region  = var.aws_region

  # Optional: Configure MAIL FROM if needed
  # mail_from_subdomain = "mail"
  # route53_zone_id     = var.route53_zone_id
}

# AWS Core module
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "dev"
  aws_region  = var.aws_region

  s3_buckets = {
    "dev-assets" = {
      bucket_name          = "fascinante-dev-assets"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Development assets"
        Type    = "Static files"
      }
    }
    "dev-backups" = {
      bucket_name          = "fascinante-dev-backups"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Development backups"
        Type    = "Backup storage"
      }
    }
  }

  sqs_queues = {
    "dev-email-queue" = {
      queue_name                 = "fascinante-dev-email-queue"
      delay_seconds              = 0
      max_message_size           = 262144
      message_retention_seconds  = 1209600
      visibility_timeout_seconds = 30
      dead_letter_queue = {
        max_receive_count = 3
      }
      tags = {
        Purpose = "Development email processing"
        Type    = "Message queue"
      }
    }
  }
}
