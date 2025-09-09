variable "aws_region" {
  description = "AWS region for SES"
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "Domain name for SES identity"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "mail_from_subdomain" {
  description = "MAIL FROM subdomain (e.g., 'mail' for mail.fascinantedigital.com)"
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Route53 zone ID for automatic DNS record creation (optional)"
  type        = string
  default     = null
}
