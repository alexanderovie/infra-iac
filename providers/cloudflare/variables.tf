variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name to manage"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "a_records" {
  description = "Map of A records to create"
  type = map(object({
    value   = string
    ttl     = optional(number, 1) # 1 = auto TTL
    proxied = optional(bool, false)
    comment = optional(string, "")
  }))
  default = {}
}

variable "cname_records" {
  description = "Map of CNAME records to create"
  type = map(object({
    value   = string
    ttl     = optional(number, 1) # 1 = auto TTL
    proxied = optional(bool, false)
    comment = optional(string, "")
  }))
  default = {}
}

variable "txt_records" {
  description = "Map of TXT records to create"
  type = map(object({
    value   = string
    ttl     = optional(number, 1) # 1 = auto TTL
    comment = optional(string, "")
  }))
  default = {}
}

variable "mx_records" {
  description = "Map of MX records to create"
  type = map(object({
    value    = string
    priority = number
    ttl      = optional(number, 1) # 1 = auto TTL
    comment  = optional(string, "")
  }))
  default = {}
}

variable "create_spf_record" {
  description = "Whether to create SPF record"
  type        = bool
  default     = false
}

variable "spf_value" {
  description = "SPF record value"
  type        = string
  default     = "v=spf1 include:_spf.google.com ~all"
}

variable "create_dmarc_record" {
  description = "Whether to create DMARC record"
  type        = bool
  default     = false
}

variable "dmarc_value" {
  description = "DMARC record value"
  type        = string
  default     = "v=DMARC1; p=quarantine; rua=mailto:dmarc@fascinantedigital.com"
}

variable "dkim_tokens" {
  description = "Map of DKIM tokens from SES"
  type        = map(string)
  default     = {}
}
