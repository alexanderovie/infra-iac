# AWS SES provider module for Fascinante Digital
# Maneja identidad de dominio, DKIM y MAIL FROM (compatible AWS provider v5.x y TF/Tofu >= 1.10)

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------
# SES: Identidad de dominio
# (NO soporta tags; no los declares)
# -----------------------------
resource "aws_ses_domain_identity" "main" {
  domain = var.domain

  lifecycle {
    prevent_destroy = true
  }
}

# -----------------------------
# SES: DKIM (3 tokens normalmente)
# -----------------------------
resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

# -----------------------------
# SES: MAIL FROM (opcional)
# -----------------------------
resource "aws_ses_domain_mail_from" "main" {
  count = var.mail_from_subdomain != null ? 1 : 0

  domain           = aws_ses_domain_identity.main.domain
  mail_from_domain = var.mail_from_subdomain

  depends_on = [aws_ses_domain_identity.main]
}

# -----------------------------
# Route53: Registros para MAIL FROM (opcional)
# -----------------------------
resource "aws_route53_record" "mail_from_mx" {
  count = var.mail_from_subdomain != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.mail_from_subdomain
  type    = "MX"
  ttl     = 600
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]

  depends_on = [aws_ses_domain_mail_from.main]
}

resource "aws_route53_record" "mail_from_spf" {
  count = var.mail_from_subdomain != null && var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.mail_from_subdomain
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com ~all"]

  depends_on = [aws_ses_domain_mail_from.main]
}

# -----------------------------
# Route53: Verificación de dominio SES
# -----------------------------
resource "aws_route53_record" "domain_verification" {
  count = var.route53_zone_id != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.main.verification_token]
}

# -----------------------------
# Route53: CNAMEs de DKIM (3 registros)
# -----------------------------
resource "aws_route53_record" "dkim" {
  count = var.route53_zone_id != null ? length(aws_ses_domain_dkim.main.dkim_tokens) : 0

  zone_id = var.route53_zone_id
  name    = "${aws_ses_domain_dkim.main.dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${aws_ses_domain_dkim.main.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# -----------------------------
# SES: Verificación final (espera a TXT)
# -----------------------------
resource "aws_ses_domain_identity_verification" "main" {
  count = var.route53_zone_id != null ? 1 : 0

  domain = aws_ses_domain_identity.main.id

  timeouts {
    create = "5m"
  }

  depends_on = [aws_route53_record.domain_verification]
}