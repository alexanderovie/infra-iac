# SÚPER-ÉLITE Configuration for Fascinante Digital Infrastructure
# This file demonstrates the complete SÚPER-ÉLITE setup

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
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
  name    = "www"
  content = "cname.vercel-dns.com"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_dns_record" "root" {
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
  name    = "@"
  content = "192.0.2.1"
  type    = "A"
  ttl     = 300
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
  zone_id = "6d7328e7f3edb975ef1f52cdb29178b7"
  name    = "stage"
  content = "cname.vercel-dns.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

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
