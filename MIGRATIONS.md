# Guía de Migraciones - Fascinante Digital

Esta guía explica cómo migrar recursos existentes a Terraform y manejar cambios en la infraestructura.

## 🔄 Migración de Recursos Existentes

### 1. Identificar Recursos Existentes

Antes de migrar, identifica todos los recursos que ya existen:

```bash
# AWS - Listar recursos
aws s3 ls
aws dynamodb list-tables
aws ses get-identity-verification-attributes

# Cloudflare - Listar zonas y registros
curl -X GET "https://api.cloudflare.com/client/v4/zones" \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

### 2. Importar Recursos a Terraform

#### S3 Buckets

```bash
# Importar bucket existente
terraform import aws_s3_bucket.generic_buckets[\"existing-bucket\"] existing-bucket-name

# Verificar importación
terraform state show aws_s3_bucket.generic_buckets[\"existing-bucket\"]
```

#### DynamoDB Tables

```bash
# Importar tabla existente
terraform import aws_dynamodb_table.terraform_locks existing-table-name

# Verificar importación
terraform state show aws_dynamodb_table.terraform_locks
```

#### Cloudflare Records

```bash
# Importar registro A
terraform import cloudflare_record.a_records[\"@\"] ZONE_ID/RECORD_ID

# Importar registro CNAME
terraform import cloudflare_record.cname_records[\"www\"] ZONE_ID/RECORD_ID
```

#### SES Domain Identity

```bash
# Importar identidad de dominio
terraform import aws_ses_domain_identity.main example.com

# Verificar importación
terraform state show aws_ses_domain_identity.main
```

### 3. Verificar Configuración

Después de importar, verifica que la configuración coincida:

```bash
# Plan para verificar diferencias
terraform plan

# Si hay diferencias, ajusta la configuración
# y ejecuta plan nuevamente
```

## 🔧 Manejo de Cambios

### Cambios en DNS

#### Agregar Nuevo Registro

```hcl
# En el módulo de Cloudflare
a_records = {
  "@" = {
    value   = "192.0.2.1"
    proxied = true
  }
  "new-subdomain" = {  # Nuevo registro
    value   = "192.0.2.2"
    proxied = true
  }
}
```

#### Modificar Registro Existente

```hcl
# Cambiar IP de un registro existente
a_records = {
  "@" = {
    value   = "192.0.2.3"  # Nueva IP
    proxied = true
  }
}
```

### Cambios en S3

#### Agregar Nuevo Bucket

```hcl
# En el módulo de AWS Core
s3_buckets = {
  "existing-bucket" = {
    bucket_name = "existing-bucket"
  }
  "new-bucket" = {  # Nuevo bucket
    bucket_name = "new-bucket"
  }
}
```

#### Modificar Configuración de Bucket

```hcl
# Cambiar configuración de bucket existente
s3_buckets = {
  "existing-bucket" = {
    bucket_name          = "existing-bucket"
    versioning_enabled   = true  # Cambio de configuración
    encryption_algorithm = "AES256"
  }
}
```

### Cambios en SES

#### Agregar MAIL FROM

```hcl
# En el módulo de SES
module "ses" {
  source = "../../providers/aws-ses"

  domain                = "example.com"
  environment           = "prod"
  aws_region            = "us-east-1"
  mail_from_subdomain   = "mail"  # Nuevo MAIL FROM
  route53_zone_id       = "Z1234567890"
}
```

## 🚨 Migraciones Críticas

### Migración de Estado

#### Cambiar Backend

```bash
# 1. Hacer backup del estado actual
terraform state pull > backup.tfstate

# 2. Configurar nuevo backend
terraform init -backend-config=new-backend.hcl

# 3. Migrar estado
terraform init -migrate-state

# 4. Verificar migración
terraform state list
```

#### Cambiar Clave de Estado

```bash
# 1. Hacer backup
terraform state pull > backup.tfstate

# 2. Cambiar clave en backend.hcl
# key = "infra/new-key.tfstate"

# 3. Migrar estado
terraform init -migrate-state

# 4. Verificar
terraform state list
```

### Migración de Módulos

#### Cambiar Ubicación de Módulo

```hcl
# Antes
module "cloudflare" {
  source = "../../providers/cloudflare"
  # ...
}

# Después
module "cloudflare" {
  source = "../../providers/cloudflare-v2"  # Nueva ubicación
  # ...
}
```

#### Cambiar Versión de Módulo

```hcl
# Antes
module "cloudflare" {
  source = "../../providers/cloudflare"
  # ...
}

# Después
module "cloudflare" {
  source = "../../providers/cloudflare?ref=v2.0.0"  # Nueva versión
  # ...
}
```

## 🔍 Verificación Post-Migración

### 1. Verificar Estado

```bash
# Listar todos los recursos
terraform state list

# Verificar recursos específicos
terraform state show aws_s3_bucket.example
terraform state show cloudflare_record.example
```

### 2. Verificar Plan

```bash
# Plan debe mostrar "No changes"
terraform plan

# Si hay cambios, revisar configuración
```

### 3. Verificar Recursos

```bash
# AWS - Verificar buckets
aws s3 ls
aws s3api get-bucket-versioning --bucket bucket-name

# Cloudflare - Verificar registros
curl -X GET "https://api.cloudflare.com/client/v4/zones/ZONE_ID/dns_records" \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

## 🛠️ Herramientas de Migración

### Terraform Import

```bash
# Importar recurso individual
terraform import RESOURCE_TYPE.NAME RESOURCE_ID

# Importar con configuración específica
terraform import -var="key=value" RESOURCE_TYPE.NAME RESOURCE_ID
```

### Terraform State

```bash
# Mover recurso en el estado
terraform state mv SOURCE DESTINATION

# Eliminar recurso del estado
terraform state rm RESOURCE_TYPE.NAME

# Mostrar recurso específico
terraform state show RESOURCE_TYPE.NAME
```

### Scripts de Migración

```bash
#!/bin/bash
# migrate-resources.sh

# Listar recursos existentes
echo "Listing existing resources..."

# Importar recursos uno por uno
terraform import aws_s3_bucket.example existing-bucket
terraform import cloudflare_record.example ZONE_ID/RECORD_ID

# Verificar importación
terraform plan
```

## ⚠️ Advertencias

### Antes de Migrar

- **Haz backup** del estado actual
- **Verifica** que los recursos existen
- **Documenta** la configuración actual
- **Prueba** en un entorno de desarrollo

### Durante la Migración

- **Importa** un recurso a la vez
- **Verifica** cada importación
- **Ajusta** la configuración si es necesario
- **No apliques** cambios hasta verificar todo

### Después de Migrar

- **Verifica** que no hay cambios en el plan
- **Prueba** la funcionalidad
- **Documenta** los cambios realizados
- **Comunica** los cambios al equipo

## 📞 Soporte

Si encuentras problemas durante la migración:

1. **Revisa** los logs de Terraform
2. **Consulta** la documentación oficial
3. **Busca** en GitHub Issues
4. **Contacta** al equipo de infraestructura

---

**Recuerda**: La migración es un proceso crítico. Tómate tu tiempo y verifica cada paso.
