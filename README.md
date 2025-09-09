# 🏗️ Infraestructura como Código - Fascinante Digital

> **Repo 0 (Identidad y Control)** - Gestión centralizada de infraestructura con OpenTofu

## 🎯 Objetivo

Este repositorio gestiona la infraestructura base de **Fascinante Digital** usando **OpenTofu (Terraform)**. Proporciona una base sólida y escalable para el despliegue y gestión de recursos en la nube, siguiendo las mejores prácticas de Infrastructure as Code (IaC).

### 🔧 Problemas que resuelve

- **Gestión centralizada** de recursos de infraestructura
- **Versionado** y control de cambios en la infraestructura
- **Reproducibilidad** de entornos (dev, stage, prod)
- **Seguridad** con backend remoto y locks distribuidos
- **Automatización** de despliegues y configuraciones

## 📋 Requisitos Previos

### Herramientas necesarias

```bash
# OpenTofu (recomendado) o Terraform
brew install opentofu

# AWS CLI
brew install awscli

# Configurar AWS CLI
aws configure
```

### Variables de entorno requeridas

```bash
# ==== ⚡️ Configuración AWS ====
export AWS_ACCESS_KEY_ID="TU_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="TU_AWS_SECRET_ACCESS_KEY"  # pragma: allowlist secret
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"

# ==== ⚡️ Configuración Cloudflare ====
export CLOUDFLARE_API_KEY="TU_CLOUDFLARE_API_KEY"  # pragma: allowlist secret
export CLOUDFLARE_EMAIL="info@fascinantedigital.com"

# ==== ⚡️ Configuración GitHub ====
export GITHUB_TOKEN="TU_GITHUB_TOKEN"
export GITHUB_OWNER="alexanderovie"

# ==== ⚡️ Configuración Vercel ====
export VERCEL_TOKEN="TU_VERCEL_TOKEN"
export VERCEL_TEAM_ID="alexanderoviedo"
```

## 📁 Estructura del Repositorio

```
infra-iac/
├── 📁 bootstrap/                 # Creación de backend S3 + DynamoDB
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── 📁 providers/                 # Módulos reutilizables
│   ├── cloudflare/              # Gestión DNS
│   ├── aws-ses/                 # Configuración email
│   ├── aws-core/                # Recursos AWS genéricos
│   ├── github/                  # Gestión repositorios
│   └── vercel/                  # Despliegues frontend
├── 📁 envs/                     # Configuraciones por entorno
│   ├── dev/                     # Entorno desarrollo
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── backend.hcl
│   │   └── terraform.tfvars.example
│   ├── stage/                   # Entorno staging
│   └── prod/                    # Entorno producción
├── 📁 secrets/                  # Variables sensibles (NO COMMIT)
│   └── dev.tfvars
├── 📁 .github/workflows/        # CI/CD pipelines
│   ├── terraform-plan.yml
│   ├── terraform-apply.yml
│   └── drift-detection.yml
├── 📁 tools/                    # Configuraciones de herramientas
│   ├── .tflint.hcl
│   ├── tfsec-excludes.yml
│   └── infracost.yml
└── 📄 README.md
```

## 🚀 Comandos Básicos

### 1. Inicializar el entorno

```bash
cd envs/dev
terraform init -reconfigure
```

### 2. Planificar cambios

```bash
terraform plan -var-file=../../secrets/dev.tfvars -compact-warnings
```

### 3. Aplicar cambios

```bash
terraform apply -var-file=../../secrets/dev.tfvars -auto-approve
```

### 4. Verificar backend remoto

```bash
# Verificar state en S3
aws s3 ls s3://fascinante-digital-terraform-state/dev/

# Verificar locks en DynamoDB
aws dynamodb describe-table \
  --table-name fascinante-digital-terraform-locks \
  --region us-east-1 \
  --query 'Table.TableStatus'
```

### 5. Destruir recursos (⚠️ CUIDADO)

```bash
terraform destroy -var-file=../../secrets/dev.tfvars
```

## 🔒 Buenas Prácticas

### Seguridad

- ❌ **NUNCA** subir `*.tfvars` ni claves al repositorio
- ✅ Usar `.gitignore` con `*.tfstate`, `.terraform/`, `*.tfvars`, `.env`
- ✅ Rotar claves y tokens regularmente
- ✅ Usar backend remoto con cifrado

### Gestión de Estado

- ✅ Backend remoto en S3 con versionado
- ✅ Locks distribuidos con DynamoDB
- ✅ State compartido entre miembros del equipo
- ✅ Backup automático del state

### Desarrollo

- ✅ Usar branches para cambios de infraestructura
- ✅ Revisar planes antes de aplicar
- ✅ Documentar cambios importantes
- ✅ Usar tags consistentes en recursos

## 📊 Estado Actual

### ✅ Infraestructura Desplegada

- **Backend remoto**: S3 + DynamoDB configurado y funcionando
- **DNS Cloudflare**: Registros gestionados con Terraform
- **Credenciales**: AWS, Cloudflare, GitHub, Vercel configuradas
- **State management**: Remoto y seguro

### 🌐 Recursos DNS Activos

- `fascinantedigital.com` → A record (192.0.2.1)
- `www.fascinantedigital.com` → CNAME (cname.vercel-dns.com)
- `api.fascinantedigital.com` → CNAME (fascinantedigital.com)
- SPF record para verificación de email
- MX record para configuración de correo

## 🔮 Próximos Pasos

### Módulos Pendientes

1. **AWS SES** - Configuración de email transaccional
2. **GitHub** - Gestión automática de repositorios
3. **Vercel** - Despliegues automáticos de frontend
4. **AWS Core** - Recursos adicionales (SQS, IAM, etc.)

### Mejoras Planificadas

- [ ] Implementar módulo de monitoreo
- [ ] Configurar alertas de costos
- [ ] Añadir validaciones de seguridad
- [ ] Implementar drift detection automático

## 🛠️ Herramientas Integradas

- **OpenTofu**: Gestión de infraestructura
- **TFLint**: Linting de código Terraform
- **Trivy**: Análisis de seguridad
- **Infracost**: Estimación de costos
- **Pre-commit**: Hooks de calidad de código

## 📞 Soporte

Para dudas o problemas con la infraestructura:

- **Email**: [info@fascinantedigital.com](mailto:info@fascinantedigital.com)
- **Equipo**: Platform Team
- **Documentación**: Ver archivos en `/docs` (próximamente)

---

> **⚠️ Importante**: Este repositorio contiene configuración de infraestructura crítica. Siempre revisar los planes antes de aplicar cambios y mantener las credenciales seguras.

**Última actualización**: Septiembre 2025 | **Versión**: SÚPER-ÉLITE
