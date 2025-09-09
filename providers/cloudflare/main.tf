# Cloudflare provider module for Fascinante Digital
# Manages DNS records and domain configuration (Provider v5+)

terraform {
  required_version = ">= 1.10"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Zone lookup (v5): use filter by name
data "cloudflare_zone" "main" {
  filter = {
    name = var.domain
  }
}

# A records
resource "cloudflare_dns_record" "a_records" {
  for_each = var.a_records

  zone_id = data.cloudflare_zone.main.id
  name    = each.key
  type    = "A"
  content = each.value.value
  ttl     = try(each.value.ttl, 1)
  proxied = try(each.value.proxied, false)
  comment = try(each.value.comment, null)
}

# CNAME records
resource "cloudflare_dns_record" "cname_records" {
  for_each = var.cname_records

  zone_id = data.cloudflare_zone.main.id
  name    = each.key
  type    = "CNAME"
  content = each.value.value
  ttl     = try(each.value.ttl, 1)
  proxied = try(each.value.proxied, false)
  comment = try(each.value.comment, null)
}

# TXT records (SPF/DKIM/verify, etc.)
resource "cloudflare_dns_record" "txt_records" {
  for_each = var.txt_records

  zone_id = data.cloudflare_zone.main.id
  name    = each.key
  type    = "TXT"
  content = each.value.value
  ttl     = try(each.value.ttl, 1)
  comment = try(each.value.comment, null)
}

# MX records
resource "cloudflare_dns_record" "mx_records" {
  for_each = var.mx_records

  zone_id  = data.cloudflare_zone.main.id
  name     = each.key
  type     = "MX"
  content  = each.value.value
  priority = try(each.value.priority, 10)
  ttl      = try(each.value.ttl, 1)
  comment  = try(each.value.comment, null)
}

# Optional SPF if not included in txt_records
resource "cloudflare_dns_record" "spf_record" {
  count = var.create_spf_record ? 1 : 0

  zone_id = data.cloudflare_zone.main.id
  name    = "@"
  type    = "TXT"
  content = var.spf_value
  ttl     = 1
  comment = "SPF record for email authentication"
}

# DMARC
resource "cloudflare_dns_record" "dmarc_record" {
  count = var.create_dmarc_record ? 1 : 0

  zone_id = data.cloudflare_zone.main.id
  name    = "_dmarc"
  type    = "TXT"
  content = var.dmarc_value
  ttl     = 1
  comment = "DMARC policy for email authentication"
}

# DKIM records from SES tokens
resource "cloudflare_dns_record" "dkim_records" {
  for_each = var.dkim_tokens

  zone_id = data.cloudflare_zone.main.id
  name    = "${each.value}._domainkey"
  type    = "CNAME"
  content = "${each.value}.dkim.amazonses.com"
  ttl     = 1
  comment = "DKIM record for SES email authentication"
}