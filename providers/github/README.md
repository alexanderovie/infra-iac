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
