# SÚPER-ÉLITE Configuration for Fascinante Digital Infrastructure
# This file demonstrates the complete SÚPER-ÉLITE setup
# Updated: September 2025 - Ready for CI/CD validation

terraform {
  required_version = ">= 1.10"

  backend "s3" {
    # Configuration will be provided via backend.hcl
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "~> 1.0"
    }
  }
}

# Provider configuration
provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

provider "vercel" {
  api_token = var.vercel_api_token
}

# Cloudflare zone lookup
data "cloudflare_zone" "main" {
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
}

# DNS Records - SÚPER-ÉLITE Setup
resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "www"
  type    = "CNAME"
  content = "cname.vercel-dns.com"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "root" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "@"
  type    = "CNAME"
  content = "cname.vercel-dns.com"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "api" {
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
  name    = "api"
  content = "fascinantedigital.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "verification" {
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
  name    = "@"
  content = "v=spf1 include:_spf.google.com ~all"
  type    = "TXT"
  ttl     = 300
}

resource "cloudflare_dns_record" "mx" {
  zone_id  = "6d7328e7f3edb975ef1f52cdb29178b7"
  name     = "@"
  content  = "mail.fascinantedigital.com"
  type     = "MX"
  priority = 10
  ttl      = 300
}

# DNS Records for Vercel Project
# Project: fascinante-digital-app
# Manual Vercel configuration required

# DNS Record for staging subdomain
resource "cloudflare_dns_record" "stage" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "stage"
  content = "cname.vercel-dns.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

# Cloudflare Redirect Rules (SÚPER-ÉLITE - Modern approach)
# Migrated from deprecated Page Rules to Redirect Rules
resource "cloudflare_ruleset" "redirect_www_to_root" {
  zone_id = data.cloudflare_zone.main.zone_id
  name    = "Redirect www to root (SÚPER-ÉLITE)"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = [
    {
      description = "301 www → root (SÚPER-ÉLITE)"
      expression  = "(http.host eq \"www.fascinantedigital.com\")"
      action      = "redirect"
      action_parameters = {
        from_value = {
          status_code = 301
          target_url = {
            value = "https://fascinantedigital.com"
          }
          preserve_query_string = true
        }
      }
      enabled = true
    }
  ]
}

# Legacy Page Rule (to be removed after migration)
# resource "cloudflare_page_rule" "redirect_www_to_root" {
#   zone_id = data.cloudflare_zone.main.zone_id
#   target  = "www.fascinantedigital.com/*"
#   status  = "active"
#   actions = {
#     forwarding_url = {
#       url         = "https://fascinantedigital.com/$1"
#       status_code = 301
#     }
#   }
# }

# SÚPER-ÉLITE Outputs
output "zone_id" {
  description = "Cloudflare zone ID"
  value       = data.cloudflare_zone.main.id
}

output "zone_name" {
  description = "Cloudflare zone name"
  value       = data.cloudflare_zone.main.name
}

output "dns_records" {
  description = "SÚPER-ÉLITE DNS records created"
  value = {
    www          = cloudflare_dns_record.www.id
    root         = cloudflare_dns_record.root.id
    api          = cloudflare_dns_record.api.id
    verification = cloudflare_dns_record.verification.id
    mx           = cloudflare_dns_record.mx.id
    stage        = cloudflare_dns_record.stage.id
  }
}

output "staging_dns_record" {
  description = "Staging subdomain DNS record"
  value = {
    id      = cloudflare_dns_record.stage.id
    name    = "stage.fascinantedigital.com"
    content = "cname.vercel-dns.com"
    type    = "CNAME"
    proxied = true
  }
}
