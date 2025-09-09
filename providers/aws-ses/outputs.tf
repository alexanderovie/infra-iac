output "domain_identity_arn" {
  description = "ARN of the SES domain identity"
  value       = aws_ses_domain_identity.main.arn
}

output "domain_identity_verification_token" {
  description = "Verification token for domain identity"
  value       = aws_ses_domain_identity.main.verification_token
}

output "verification_txt_name" {
  description = "Name for the TXT record to verify domain ownership"
  value       = "_amazonses.${var.domain}"
}

output "verification_txt_value" {
  description = "Value for the TXT record to verify domain ownership"
  value       = aws_ses_domain_identity.main.verification_token
}

output "dkim_tokens" {
  description = "DKIM tokens for the domain"
  value       = aws_ses_domain_dkim.main.dkim_tokens
}

output "dkim_cname_records" {
  description = "CNAME records needed for DKIM verification"
  value = {
    for i, token in aws_ses_domain_dkim.main.dkim_tokens : i => {
      name  = "${token}._domainkey.${var.domain}"
      value = "${token}.dkim.amazonses.com"
    }
  }
}

output "mail_from_domain" {
  description = "MAIL FROM domain"
  value       = var.mail_from_subdomain != null ? "${var.mail_from_subdomain}.${var.domain}" : null
}

output "mail_from_mx_record" {
  description = "MX record for MAIL FROM domain"
  value = var.mail_from_subdomain != null ? {
    name  = var.mail_from_subdomain
    value = "10 feedback-smtp.${var.aws_region}.amazonses.com"
    type  = "MX"
  } : null
}

output "mail_from_spf_record" {
  description = "SPF record for MAIL FROM domain"
  value = var.mail_from_subdomain != null ? {
    name  = var.mail_from_subdomain
    value = "v=spf1 include:amazonses.com ~all"
    type  = "TXT"
  } : null
}

output "domain_verified" {
  description = "Whether the domain is verified (only available if Route53 zone ID is provided)"
  value       = var.route53_zone_id != null ? aws_ses_domain_identity_verification.main[0].id : null
}

output "dkim_verified" {
  description = "Whether DKIM is verified (only available if Route53 zone ID is provided)"
  value       = var.route53_zone_id != null ? aws_ses_domain_dkim.main.dkim_tokens : null
}
