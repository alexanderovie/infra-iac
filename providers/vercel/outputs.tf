output "projects" {
  description = "Map of Vercel project information"
  value = {
    for k, v in vercel_project.projects : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "domains" {
  description = "Map of Vercel project domain information"
  value = {
    for k, v in vercel_project_domain.domains : k => {
      id         = v.id
      domain     = v.domain
      project_id = v.project_id
    }
  }
}

output "environment_variables" {
  description = "Map of environment variables"
  value = {
    for k, v in vercel_project_environment_variable.env_vars : k => {
      project_id = v.project_id
      key        = v.key
      target     = v.target
    }
  }
}
