# GitHub Provider Module

Este módulo gestiona repositorios de GitHub, secretos, variables y reglas de protección de ramas para Fascinante Digital.

## Características

- **Repositorios**: Creación y configuración de repositorios
- **Secretos**: Gestión de secretos de GitHub Actions
- **Variables**: Gestión de variables de GitHub Actions
- **Protección de ramas**: Reglas de protección para ramas principales
- **Templates**: Soporte para repositorios basados en templates

## Uso

### Variables requeridas

```hcl
github_token = "ghp_xxxxxxxxxxxx"
environment = "prod"
```

### Ejemplo básico

```hcl
module "github" {
  source = "../../providers/github"

  github_token = var.github_token
  environment  = "prod"
}
```

### Ejemplo con repositorios

```hcl
module "github" {
  source = "../../providers/github"

  github_token = var.github_token
  environment  = "prod"

  repositories = {
    "fascinante-web" = {
      name        = "fascinante-web"
      description = "Fascinante Digital website"
      visibility  = "private"
      auto_init   = true
      topics      = ["website", "react", "typescript"]
      secrets = {
        "AWS_ACCESS_KEY_ID"     = var.aws_access_key_id
        "AWS_SECRET_ACCESS_KEY" = var.aws_secret_access_key
        "CLOUDFLARE_API_TOKEN"  = var.cloudflare_api_token
      }
      variables = {
        "NODE_VERSION" = "18"
        "AWS_REGION"   = "us-east-1"
      }
    }
    "fascinante-api" = {
      name        = "fascinante-api"
      description = "Fascinante Digital API"
      visibility  = "private"
      auto_init   = true
      topics      = ["api", "nodejs", "express"]
      secrets = {
        "DATABASE_URL" = var.database_url
        "JWT_SECRET"   = var.jwt_secret
      }
      variables = {
        "NODE_ENV" = "production"
        "PORT"     = "3000"
      }
    }
  }
}
```

### Ejemplo con protección de ramas

```hcl
module "github" {
  source = "../../providers/github"

  github_token = var.github_token
  environment  = "prod"

  repositories = {
    "fascinante-web" = {
      name = "fascinante-web"
      # ... other config
    }
  }

  branch_protections = {
    "main-protection" = {
      repository = "fascinante-web"
      pattern    = "main"

      required_status_checks = {
        strict   = true
        contexts = ["ci/lint", "ci/test", "ci/build"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = 2
      }

      push_restrictions = []
      allows_force_pushes = false
      allows_deletions    = false
      required_linear_history = true
      enforce_admins = true
    }
  }
}
```

## Outputs

- `repositories`: Información de repositorios creados
- `repository_secrets`: Secretos configurados
- `repository_variables`: Variables configuradas
- `branch_protections`: Reglas de protección de ramas

## Configuración de repositorios

### Visibilidad

- `private`: Repositorio privado (recomendado)
- `public`: Repositorio público
- `internal`: Repositorio interno (solo organizaciones)

### Características

- `has_issues`: Habilita issues
- `has_projects`: Habilita proyectos
- `has_wiki`: Habilita wiki
- `has_downloads`: Habilita descargas
- `auto_init`: Inicializa con README

### Merge options

- `allow_merge_commit`: Permite merge commits
- `allow_squash_merge`: Permite squash merge
- `allow_rebase_merge`: Permite rebase merge
- `delete_branch_on_merge`: Elimina rama después del merge

## Secretos y variables

### Secretos

- Se almacenan encriptados en GitHub
- Solo visibles para GitHub Actions
- No se pueden leer una vez creados

### Variables

- Se almacenan en texto plano
- Visibles para todos los usuarios con acceso
- Usar solo para valores no sensibles

## Protección de ramas

### Status checks requeridos

- `strict`: Requiere que los checks estén actualizados
- `contexts`: Lista de checks requeridos

### Pull request reviews

- `dismiss_stale_reviews`: Descartar reviews obsoletas
- `require_code_owner_reviews`: Requerir reviews de code owners
- `required_approving_review_count`: Número mínimo de aprobaciones

### Restricciones

- `push_restrictions`: Lista de usuarios/equipos que pueden hacer push
- `allows_force_pushes`: Permite force push
- `allows_deletions`: Permite eliminar la rama
- `required_linear_history`: Requiere historial lineal
- `enforce_admins`: Aplica reglas a administradores

## ⚠️ Consideraciones

- **Token**: Usa tokens con permisos mínimos necesarios
- **Secretos**: No incluyas secretos en el código
- **Protección**: Las reglas de protección son importantes para la seguridad
- **Templates**: Los templates deben existir antes de usarlos
- **Límites**: GitHub tiene límites en el número de repositorios
- **Costos**: Los repositorios privados pueden tener costos asociados

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 5.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_secret.repo_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.repo_variables](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch_protection.branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_repository.repos](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_branch_protections"></a> [branch\_protections](#input\_branch\_protections) | Map of branch protection rules | <pre>map(object({<br/>    repository = string<br/>    pattern    = string<br/><br/>    # Required status checks<br/>    required_status_checks = object({<br/>      strict   = bool<br/>      contexts = list(string)<br/>    })<br/><br/>    # Required pull request reviews<br/>    required_pull_request_reviews = object({<br/>      dismiss_stale_reviews           = bool<br/>      require_code_owner_reviews      = bool<br/>      required_approving_review_count = number<br/>    })<br/><br/>    # Push restrictions<br/>    push_restrictions = optional(list(string), [])<br/><br/>    # Other settings<br/>    allows_force_pushes     = optional(bool, false)<br/>    allows_deletions        = optional(bool, false)<br/>    required_linear_history = optional(bool, false)<br/>    enforce_admins          = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, stage, prod) | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub personal access token | `string` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Map of GitHub repositories to create | <pre>map(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    visibility  = optional(string, "private")<br/>    auto_init   = optional(bool, true)<br/><br/>    # Repository features<br/>    has_issues             = optional(bool, true)<br/>    has_projects           = optional(bool, false)<br/>    has_wiki               = optional(bool, false)<br/>    has_downloads          = optional(bool, true)<br/>    allow_merge_commit     = optional(bool, true)<br/>    allow_squash_merge     = optional(bool, true)<br/>    allow_rebase_merge     = optional(bool, true)<br/>    delete_branch_on_merge = optional(bool, true)<br/><br/>    # Topics<br/>    topics = optional(list(string), [])<br/><br/>    # Template<br/>    template = optional(object({<br/>      owner      = string<br/>      repository = string<br/>    }), null)<br/><br/>    # Secrets and variables<br/>    secrets   = optional(map(string), {})<br/>    variables = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_branch_protections"></a> [branch\_protections](#output\_branch\_protections) | Map of branch protection rules |
| <a name="output_repositories"></a> [repositories](#output\_repositories) | Map of GitHub repository information |
| <a name="output_repository_secrets"></a> [repository\_secrets](#output\_repository\_secrets) | Map of repository secrets |
| <a name="output_repository_variables"></a> [repository\_variables](#output\_repository\_variables) | Map of repository variables |
<!-- END_TF_DOCS -->
