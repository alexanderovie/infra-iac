# Fascinante Digital - Infrastructure as Code

Este repositorio contiene toda la infraestructura de Fascinante Digital gestionada con **Terraform**. Es el **Repo 0 (Identidad y Control)** que centraliza la gestión de infraestructura, DNS, email, y servicios de soporte.

## 🏗️ Arquitectura

### Módulos de Proveedores

- **`providers/cloudflare/`**: Gestión de DNS y dominios
- **`providers/aws-ses/`**: Configuración de email con Amazon SES
- **`providers/aws-core/`**: Recursos básicos de AWS (S3, SQS, IAM)
- **`providers/github/`**: Gestión de repositorios y secretos (opcional)
- **`providers/vercel/`**: Proyectos y dominios de Vercel (opcional)

### Entornos

- **`envs/dev/`**: Entorno de desarrollo
- **`envs/stage/`**: Entorno de staging
- **`envs/prod/`**: Entorno de producción

### Bootstrap

- **`bootstrap/`**: Configuración inicial de S3 y DynamoDB para estado de Terraform

## 🚀 Inicio Rápido

### 1. Prerrequisitos

- **Terraform** >= 1.6
- **AWS CLI** configurado
- **Cloudflare API Token**
- Acceso a AWS (S3, DynamoDB, SES)
- Acceso a Cloudflare (DNS)

### 2. Bootstrap (Solo una vez)

```bash
# 1. Ir al directorio bootstrap
cd bootstrap/

# 2. Configurar variables
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores

# 3. Inicializar y aplicar
terraform init
terraform plan
terraform apply

# 4. Guardar outputs
terraform output -json > outputs.json
```

### 3. Configurar un Entorno

```bash
# 1. Ir al directorio del entorno
cd envs/dev/

# 2. Configurar variables
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores

# 3. Inicializar con backend
terraform init -backend-config=backend.hcl

# 4. Planificar cambios
terraform plan

# 5. Aplicar cambios
terraform apply
```

## 📋 Configuración por Entorno

### Variables Requeridas

Cada entorno necesita estas variables en `terraform.tfvars`:

```hcl
# AWS Configuration
aws_region = "us-east-1"

# Cloudflare Configuration
cloudflare_api_token = "your-cloudflare-api-token"

# Domain Configuration
domain = "fascinantedigital.com"

# IP Addresses (ajustar según tu infraestructura)
main_ip = "192.0.2.1"
```

### Secretos de GitHub

Configura estos secretos en tu repositorio de GitHub:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFLARE_API_TOKEN`

## 🔧 Uso de Módulos

### Cloudflare

```hcl
module "cloudflare" {
  source = "../../providers/cloudflare"

  cloudflare_api_token = var.cloudflare_api_token
  domain              = "fascinantedigital.com"
  environment         = "prod"

  a_records = {
    "@" = {
      value   = "192.0.2.1"
      proxied = true
    }
  }
}
```

### AWS SES

```hcl
module "ses" {
  source = "../../providers/aws-ses"

  domain      = "fascinantedigital.com"
  environment = "prod"
  aws_region  = "us-east-1"
}
```

### AWS Core

```hcl
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = "us-east-1"

  s3_buckets = {
    "assets" = {
      bucket_name = "fascinante-assets"
    }
  }
}
```

## 🔄 CI/CD

### Workflows de GitHub Actions

- **`terraform-plan.yml`**: Ejecuta en cada PR
  - Formato de código
  - Linting con TFLint
  - Escaneo de seguridad con TFSec
  - Plan de Terraform
  - Comentarios en PR

- **`terraform-apply.yml`**: Ejecuta en main
  - Aplicación automática de cambios
  - Aprobación manual opcional
  - Notificaciones de estado

### Ejecutar Manualmente

```bash
# Plan para un entorno específico
gh workflow run terraform-plan.yml

# Apply para un entorno específico
gh workflow run terraform-apply.yml -f environment=prod
```

## 📚 Documentación Adicional

- **[MIGRATIONS.md](MIGRATIONS.md)**: Guía de migración y importación
- **[SECURITY.md](SECURITY.md)**: Buenas prácticas de seguridad
- **[CONTRIBUTING.md](CONTRIBUTING.md)**: Guía de contribución
- **[bootstrap/README.md](bootstrap/README.md)**: Configuración inicial
- **[providers/*/README.md](providers/)**: Documentación de módulos

## 🛠️ Herramientas

### TFLint

```bash
# Instalar
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Ejecutar
tflint --config tools/.tflint.hcl
```

### TFSec

```bash
# Instalar
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Ejecutar
tfsec --config-file tools/tfsec-excludes.yml
```

### Infracost

```bash
# Instalar
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Ejecutar
infracost breakdown --config-file tools/infracost.yml
```

## ⚠️ Advertencias Importantes

### Seguridad

- **NUNCA** commitees archivos `terraform.tfvars`
- **NUNCA** incluyas secretos en el código
- **SIEMPRE** usa secretos de GitHub para valores sensibles
- **SIEMPRE** revisa los planes antes de aplicar

### Estado de Terraform

- **NUNCA** elimines el bucket S3 de estado
- **NUNCA** elimines la tabla DynamoDB de locks
- **SIEMPRE** usa `terraform import` para recursos existentes
- **SIEMPRE** haz backup del estado antes de cambios grandes

### Cambios Manuales

- **NUNCA** modifiques recursos manualmente en la consola
- **SIEMPRE** usa Terraform para todos los cambios
- **SIEMPRE** documenta cambios en PRs

## 🆘 Solución de Problemas

### Error de Backend

```bash
# Si el backend no existe, inicializa sin backend
terraform init -backend=false

# Luego migra al backend
terraform init -backend-config=backend.hcl
```

### Error de Estado

```bash
# Listar recursos en el estado
terraform state list

# Mostrar un recurso específico
terraform state show aws_s3_bucket.example

# Importar un recurso existente
terraform import aws_s3_bucket.example bucket-name
```

### Error de Providers

```bash
# Actualizar providers
terraform init -upgrade

# Limpiar cache
rm -rf .terraform/
terraform init
```

## 📞 Soporte

- **Issues**: Usa GitHub Issues para reportar problemas
- **Discusiones**: Usa GitHub Discussions para preguntas
- **Documentación**: Consulta los README de cada módulo

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

**Fascinante Digital** - Infraestructura como Código
