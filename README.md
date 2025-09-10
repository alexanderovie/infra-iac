# 🏗️ Infraestructura como Código - Fascinante Digital

> **Repo 0 (Identidad y Control)** - Gestión centralizada de infraestructura con
> OpenTofu

## 🎯 Objetivo

Este repositorio gestiona la infraestructura base de **Fascinante Digital**
usando **OpenTofu (Terraform)**. Proporciona una base sólida y escalable para el
despliegue y gestión de recursos en la nube, siguiendo las mejores prácticas de
Infrastructure as Code (IaC).

### 🔧 Problemas que resuelve

- **Gestión centralizada** de recursos de infraestructura
- **Versionado** y control de cambios en la infraestructura
- **Reproducibilidad** de entornos (dev, stage, prod)
- **Seguridad** con backend remoto y locks distribuidos
- **Automatización** de despliegues y configuraciones

## 📋 Requisitos Previos

### Herramientas necesarias

```bash
# 1Password CLI v2
brew install 1password-cli

# OpenTofu (recomendado) o Terraform
brew install opentofu

# AWS CLI
brew install awscli
```

### Configuración 1Password CLI v2

```bash
# Alias recomendado para login rápido
alias op-login='eval $(op signin)'

# 1. Autenticarse en 1Password CLI
op-login

# 2. Verificar autenticación
op whoami && op vault list
```

### Gestión de Secretos con 1Password

Los secretos se gestionan automáticamente a través de 1Password CLI v2. No
necesitas variables de entorno locales.

```bash
# Migrar secretos a 1Password (solo la primera vez)
make tf-migrate-1password

# Editar valores reales
op item edit 'AWS – Prod' --vault 'Fascinante Digital Infrastructure' 'Access Key ID=TU_ACCESS_KEY'
op item edit 'AWS – Prod' --vault 'Fascinante Digital Infrastructure' 'Secret Access Key=TU_SECRET_KEY'
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

### 1Password CLI v2 + Terraform

```bash
# 1. Autenticarse en 1Password
make op-login

# 2. Verificar configuración
make op-check

# 3. Migrar secretos (solo primera vez)
make tf-migrate-1password

# 4. Editar valores reales en 1Password
op item edit 'AWS – Prod' --vault 'Fascinante Digital Infrastructure' 'Access Key ID=TU_ACCESS_KEY'

# 5. Comandos Terraform con 1Password
make tf-init      # Inicializar
make tf-plan      # Planificar
make tf-apply     # Aplicar
make tf-validate  # Validar
make tf-state     # Listar recursos
```

### Comandos de Validación

```bash
# Verificar que todo funciona
make op-login && make op-check
make tf-migrate-1password
# editar valores reales con 'op item edit ...'
make tf-plan
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

## 🔄 CI/CD con GitHub Actions

El workflow automático usa 1Password Service Account para acceder a los
secretos:

```yaml
# .github/workflows/terraform.yml
name: Terraform Plan (1Password)
on:
  workflow_dispatch:
  push: { branches: [main] }
jobs:
  plan:
    runs-on: ubuntu-latest
    env:
      OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.ONEPASSWORD_SERVICE_ACCOUNT_TOKEN }}
    steps:
      - uses: actions/checkout@v4
      - uses: 1password/install-cli-action@v1
      - uses: hashicorp/setup-terraform@v3
        with: { terraform_version: 1.9.5 }
      - name: Init
        run:
          op run --env-file=<(source scripts/export-env-1password.sh) --
          terraform init -upgrade
      - name: Plan
        run:
          op run --env-file=<(source scripts/export-env-1password.sh) --
          terraform plan -no-color
```

### Configurar Service Account

1. Crear Service Account en 1Password con acceso de solo lectura al vault
2. Añadir el token como secret `ONEPASSWORD_SERVICE_ACCOUNT_TOKEN` en GitHub
3. El workflow se ejecutará automáticamente en cada push a main

### Comandos Makefile disponibles

```bash
# 1Password CLI v2
make op-login              # Autenticarse en 1Password
make op-check              # Verificar autenticación y vaults
make tf-migrate-1password  # Migrar secretos a 1Password

# Terraform con 1Password
make tf-init      # Inicializar Terraform
make tf-plan      # Planificar cambios
make tf-apply     # Aplicar cambios
make tf-validate  # Validar configuración
make tf-state     # Listar recursos
make tf-fmt       # Formatear código
make tf-sh        # Shell interactivo
```

## 📞 Soporte

Para dudas o problemas con la infraestructura:

- **Email**: [info@fascinantedigital.com](mailto:info@fascinantedigital.com)
- **Equipo**: Platform Team
- **Documentación**: Ver archivos en `/docs` (próximamente)

---

> **⚠️ Importante**: Este repositorio contiene configuración de infraestructura
> crítica. Siempre revisar los planes antes de aplicar cambios y mantener las
> credenciales seguras.

**Última actualización**: Septiembre 2025 | **Versión**: SÚPER-ÉLITE
