variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name to manage"
  type        = string
  default     = "fascinantedigital.com"
}

variable "main_ip" {
  description = "Main IP address for A records"
  type        = string
  default     = "192.0.2.1"
}

variable "dev_ip" {
  description = "Development environment IP address"
  type        = string
  default     = "192.0.2.2"
}

variable "route53_zone_id" {
  description = "Route53 zone ID for automatic DNS record creation (optional)"
  type        = string
  default     = null
}
