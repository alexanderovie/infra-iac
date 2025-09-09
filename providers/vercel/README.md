# Vercel Provider Module

Este módulo gestiona proyectos de Vercel, dominios y variables de entorno para Fascinante Digital.

## Características

- **Proyectos**: Creación y configuración de proyectos de Vercel
- **Dominios**: Gestión de dominios personalizados
- **Variables de entorno**: Configuración de variables por entorno
- **Integración Git**: Conexión con repositorios de GitHub
- **Configuración de build**: Comandos personalizados de build

## Uso

### Variables requeridas

```hcl
vercel_api_token = "vercel_xxxxxxxxxxxx"
environment     = "prod"
```

### Ejemplo básico

```hcl
module "vercel" {
  source = "../../providers/vercel"

  vercel_api_token = var.vercel_api_token
  environment      = "prod"
}
```

### Ejemplo con proyectos

```hcl
module "vercel" {
  source = "../../providers/vercel"

  vercel_api_token = var.vercel_api_token
  environment      = "prod"

  projects = {
    "fascinante-web" = {
      name = "fascinante-web"
      git_repository = {
        type = "github"
        repo = "fascinante-digital/fascinante-web"
      }
      framework = "nextjs"
      build_command = "npm run build"
      output_directory = ".next"
      domains = ["fascinantedigital.com", "www.fascinantedigital.com"]
      environment_variables = [
        {
          key    = "NEXT_PUBLIC_API_URL"
          value  = "https://api.fascinantedigital.com"
          target = ["production", "preview"]
        }
      ]
      additional_env_vars = [
        {
          key    = "DATABASE_URL"
          value  = var.database_url
          target = ["production"]
        }
      ]
    }
  }
}
```

### Ejemplo con dominios

```hcl
module "vercel" {
  source = "../../providers/vercel"

  vercel_api_token = var.vercel_api_token
  environment      = "prod"

  projects = {
    "fascinante-web" = {
      name = "fascinante-web"
      # ... other config
    }
  }

  domains = {
    "main-domain" = {
      domain  = "fascinantedigital.com"
      project = "fascinante-web"
    }
    "www-domain" = {
      domain  = "www.fascinantedigital.com"
      project = "fascinante-web"
    }
  }
}
```

## Outputs

- `projects`: Información de proyectos creados
- `domains`: Información de dominios configurados
- `environment_variables`: Variables de entorno configuradas

## Configuración de proyectos

### Git repository

```hcl
git_repository = {
  type = "github"  # o "gitlab", "bitbucket"
  repo = "username/repository"
}
```

### Build settings

- `build_command`: Comando para construir el proyecto
- `output_directory`: Directorio de salida
- `install_command`: Comando de instalación
- `dev_command`: Comando de desarrollo
- `ignore_command`: Comando de ignorar archivos

### Frameworks soportados

- `nextjs`: Next.js
- `react`: React
- `vue`: Vue.js
- `svelte`: Svelte
- `angular`: Angular
- `nuxt`: Nuxt.js
- `gatsby`: Gatsby
- `static`: Sitio estático

## Variables de entorno

### Targets disponibles

- `production`: Solo en producción
- `preview`: Solo en preview
- `development`: Solo en desarrollo
- `["production", "preview"]`: Múltiples targets

### Ejemplo

```hcl
environment_variables = [
  {
    key    = "API_URL"
    value  = "https://api.example.com"
    target = ["production", "preview"]
  },
  {
    key    = "DEBUG"
    value  = "true"
    target = ["development"]
  }
]
```

## Dominios

### Configuración

- Los dominios deben estar verificados en Vercel
- Se pueden configurar subdominios
- Soporte para dominios personalizados

### Ejemplo

```hcl
domains = {
  "main" = {
    domain  = "fascinantedigital.com"
    project = "fascinante-web"
  }
  "api" = {
    domain  = "api.fascinantedigital.com"
    project = "fascinante-api"
  }
}
```

## Regiones de funciones serverless

### Regiones disponibles

- `iad1`: US East (Virginia)
- `sfo1`: US West (San Francisco)
- `hnd1`: Asia Pacific (Tokyo)
- `fra1`: Europe (Frankfurt)
- `syd1`: Asia Pacific (Sydney)

### Ejemplo

```hcl
serverless_function_regions = ["iad1", "sfo1"]
```

## ⚠️ Consideraciones

- **Token**: Usa tokens con permisos mínimos necesarios
- **Git**: Los repositorios deben estar conectados a Vercel
- **Dominios**: Los dominios deben estar verificados
- **Variables**: Las variables sensibles deben usar secretos
- **Límites**: Vercel tiene límites en el número de proyectos
- **Costos**: Los proyectos pueden tener costos asociados
- **Team**: Especifica `team_id` para organizaciones
