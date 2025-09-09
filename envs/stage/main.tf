# Staging environment configuration
# This file configures the staging environment for Fascinante Digital

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
  environment          = "stage"

  a_records = {
    "@" = {
      value   = var.main_ip
      proxied = true
      comment = "Main domain A record (stage)"
    }
    "www" = {
      value   = var.main_ip
      proxied = true
      comment = "WWW subdomain (stage)"
    }
    "stage" = {
      value   = var.stage_ip
      proxied = true
      comment = "Staging subdomain"
    }
  }

  cname_records = {
    "api-stage" = {
      value   = "api-stage.fascinantedigital.com"
      proxied = false
      comment = "Staging API subdomain"
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
  environment = "stage"
  aws_region  = var.aws_region

  # Optional: Configure MAIL FROM if needed
  # mail_from_subdomain = "mail"
  # route53_zone_id     = var.route53_zone_id
}

# AWS Core module
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "stage"
  aws_region  = var.aws_region

  s3_buckets = {
    "stage-assets" = {
      bucket_name          = "fascinante-stage-assets"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Staging assets"
        Type    = "Static files"
      }
    }
    "stage-backups" = {
      bucket_name          = "fascinante-stage-backups"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Staging backups"
        Type    = "Backup storage"
      }
    }
  }

  sqs_queues = {
    "stage-email-queue" = {
      queue_name                 = "fascinante-stage-email-queue"
      delay_seconds              = 0
      max_message_size           = 262144
      message_retention_seconds  = 1209600
      visibility_timeout_seconds = 30
      dead_letter_queue = {
        max_receive_count = 3
      }
      tags = {
        Purpose = "Staging email processing"
        Type    = "Message queue"
      }
    }
  }
}
