# Vercel provider module for Fascinante Digital
# Manages Vercel projects, domains, and environment variables

terraform {
  required_version = ">= 1.6"
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 1.0"
    }
  }
}

provider "vercel" {
  api_token = var.vercel_api_token
}

# Vercel projects
resource "vercel_project" "projects" {
  for_each = var.projects

  name           = each.value.name
  git_repository = each.value.git_repository

  # Build settings
  build_command    = each.value.build_command
  output_directory = each.value.output_directory
  install_command  = each.value.install_command
  dev_command      = each.value.dev_command

  # Framework
  framework = each.value.framework

  # Environment variables
  dynamic "environment" {
    for_each = each.value.environment_variables
    content {
      key    = environment.key
      value  = environment.value
      target = environment.value.target
    }
  }

  # Domains
  domains = each.value.domains

  # Team (if specified)
  team_id = var.team_id

  # Root directory
  root_directory = each.value.root_directory

  # Ignore command
  ignore_command = each.value.ignore_command

  # Serverless function regions
  serverless_function_regions = each.value.serverless_function_regions
}

# Vercel domains
resource "vercel_domain" "domains" {
  for_each = var.domains

  domain     = each.value.domain
  project_id = vercel_project.projects[each.value.project].id

  # Team (if specified)
  team_id = var.team_id
}

# Vercel environment variables
resource "vercel_project_environment_variable" "env_vars" {
  for_each = {
    for env_var in local.all_env_vars : "${env_var.project}.${env_var.key}" => env_var
  }

  project_id = vercel_project.projects[each.value.project].id
  key        = each.value.key
  value      = each.value.value
  target     = each.value.target

  # Team (if specified)
  team_id = var.team_id
}

# Local values for flattening environment variables
locals {
  all_env_vars = flatten([
    for project_name, project in var.projects : [
      for env_var in project.additional_env_vars : merge(env_var, {
        project = project_name
      })
    ]
  ])
}
