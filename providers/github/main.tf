# GitHub provider module for Fascinante Digital
# Manages GitHub repositories, secrets, and branch protections

terraform {
  required_version = ">= 1.6"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

# GitHub repositories
resource "github_repository" "repos" {
  for_each = var.repositories

  name        = each.value.name
  description = each.value.description
  visibility  = each.value.visibility
  auto_init   = each.value.auto_init

  # Repository settings
  has_issues             = each.value.has_issues
  has_projects           = each.value.has_projects
  has_wiki               = each.value.has_wiki
  has_downloads          = each.value.has_downloads
  allow_merge_commit     = each.value.allow_merge_commit
  allow_squash_merge     = each.value.allow_squash_merge
  allow_rebase_merge     = each.value.allow_rebase_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge

  # Topics
  topics = each.value.topics

  # Template (if specified)
  template {
    owner      = each.value.template.owner
    repository = each.value.template.repository
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Repository secrets
resource "github_actions_secret" "repo_secrets" {
  for_each = {
    for secret in local.all_secrets : "${secret.repository}.${secret.name}" => secret
  }

  repository      = each.value.repository
  secret_name     = each.value.name
  plaintext_value = each.value.value
}

# Repository variables
resource "github_actions_variable" "repo_variables" {
  for_each = {
    for variable in local.all_variables : "${variable.repository}.${variable.name}" => variable
  }

  repository    = each.value.repository
  variable_name = each.value.name
  value         = each.value.value
}

# Branch protection rules
resource "github_branch_protection" "branch_protection" {
  for_each = var.branch_protections

  repository_id = github_repository.repos[each.value.repository].node_id
  pattern       = each.value.pattern

  # Required status checks
  required_status_checks {
    strict   = each.value.required_status_checks.strict
    contexts = each.value.required_status_checks.contexts
  }

  # Required pull request reviews
  required_pull_request_reviews {
    dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
    require_code_owner_reviews      = each.value.required_pull_request_reviews.require_code_owner_reviews
    required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
  }

  # Push restrictions
  push_restrictions = each.value.push_restrictions

  # Allow force pushes
  allows_force_pushes = each.value.allows_force_pushes

  # Allow deletions
  allows_deletions = each.value.allows_deletions

  # Require linear history
  required_linear_history = each.value.required_linear_history

  # Enforce admins
  enforce_admins = each.value.enforce_admins
}

# Local values for flattening secrets and variables
locals {
  all_secrets = flatten([
    for repo_name, repo in var.repositories : [
      for secret_name, secret_value in repo.secrets : {
        repository = repo_name
        name       = secret_name
        value      = secret_value
      }
    ]
  ])

  all_variables = flatten([
    for repo_name, repo in var.repositories : [
      for var_name, var_value in repo.variables : {
        repository = repo_name
        name       = var_name
        value      = var_value
      }
    ]
  ])
}
