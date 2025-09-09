output "repositories" {
  description = "Map of GitHub repository information"
  value = {
    for k, v in github_repository.repos : k => {
      id         = v.id
      name       = v.name
      full_name  = v.full_name
      html_url   = v.html_url
      ssh_url    = v.ssh_url
      clone_url  = v.clone_url
      visibility = v.visibility
      created_at = v.created_at
      updated_at = v.updated_at
    }
  }
}

output "repository_secrets" {
  description = "Map of repository secrets"
  value = {
    for k, v in github_actions_secret.repo_secrets : k => {
      repository = v.repository
      name       = v.secret_name
    }
  }
}

output "repository_variables" {
  description = "Map of repository variables"
  value = {
    for k, v in github_actions_variable.repo_variables : k => {
      repository = v.repository
      name       = v.variable_name
    }
  }
}

output "branch_protections" {
  description = "Map of branch protection rules"
  value = {
    for k, v in github_branch_protection.branch_protection : k => {
      repository = v.repository_id
      pattern    = v.pattern
    }
  }
}
