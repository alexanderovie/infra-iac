variable "vercel_api_token" {
  description = "Vercel API token"
  type        = string
  sensitive   = true
}

variable "team_id" {
  description = "Vercel team ID (optional)"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "projects" {
  description = "Map of Vercel projects to create"
  type = map(object({
    name = string
    git_repository = optional(object({
      type = string
      repo = string
    }), null)

    # Build settings
    build_command    = optional(string, null)
    output_directory = optional(string, null)
    install_command  = optional(string, null)
    dev_command      = optional(string, null)
    ignore_command   = optional(string, null)
    root_directory   = optional(string, null)

    # Framework
    framework = optional(string, null)

    # Environment variables (inline)
    environment_variables = optional(list(object({
      key    = string
      value  = string
      target = list(string)
    })), [])

    # Additional environment variables
    additional_env_vars = optional(list(object({
      key    = string
      value  = string
      target = list(string)
    })), [])

    # Domains
    domains = optional(list(object({
      domain = string
    })), [])

    # Serverless function regions
    serverless_function_regions = optional(list(string), ["iad1"])
  }))
  default = {}
}

variable "domains" {
  description = "Map of Vercel domains to create"
  type = map(object({
    domain  = string
    project = string
  }))
  default = {}
}
