variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "repositories" {
  description = "Map of GitHub repositories to create"
  type = map(object({
    name        = string
    description = optional(string, "")
    visibility  = optional(string, "private")
    auto_init   = optional(bool, true)

    # Repository features
    has_issues             = optional(bool, true)
    has_projects           = optional(bool, false)
    has_wiki               = optional(bool, false)
    has_downloads          = optional(bool, true)
    allow_merge_commit     = optional(bool, true)
    allow_squash_merge     = optional(bool, true)
    allow_rebase_merge     = optional(bool, true)
    delete_branch_on_merge = optional(bool, true)

    # Topics
    topics = optional(list(string), [])

    # Template
    template = optional(object({
      owner      = string
      repository = string
    }), null)

    # Secrets and variables
    secrets   = optional(map(string), {})
    variables = optional(map(string), {})
  }))
  default = {}
}

variable "branch_protections" {
  description = "Map of branch protection rules"
  type = map(object({
    repository = string
    pattern    = string

    # Required status checks
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })

    # Required pull request reviews
    required_pull_request_reviews = object({
      dismiss_stale_reviews           = bool
      require_code_owner_reviews      = bool
      required_approving_review_count = number
    })

    # Push restrictions
    push_restrictions = optional(list(string), [])

    # Other settings
    allows_force_pushes     = optional(bool, false)
    allows_deletions        = optional(bool, false)
    required_linear_history = optional(bool, false)
    enforce_admins          = optional(bool, false)
  }))
  default = {}
}
