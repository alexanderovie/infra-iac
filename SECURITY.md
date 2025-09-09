# Guía de Seguridad - Fascinante Digital

Esta guía establece las mejores prácticas de seguridad para la infraestructura de Fascinante Digital gestionada con Terraform.

## 🔐 Gestión de Secretos

### Secretos de GitHub

#### Configuración Requerida

Configura estos secretos en tu repositorio de GitHub:

```bash
# AWS Credentials
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...

# Cloudflare
CLOUDFLARE_API_TOKEN=...

# Otros proveedores (opcional)
GITHUB_TOKEN=...
VERCEL_API_TOKEN=...
```

#### Rotación de Secretos

```bash
# 1. Generar nuevos secretos
aws iam create-access-key --user-name terraform-user

# 2. Actualizar en GitHub
# Ir a Settings > Secrets and variables > Actions
# Actualizar los secretos

# 3. Verificar funcionamiento
gh workflow run terraform-plan.yml

# 4. Eliminar secretos antiguos
aws iam delete-access-key --user-name terraform-user --access-key-id OLD_KEY
```

### Variables Sensibles

#### En Terraform

```hcl
# ✅ Correcto - Usar variables sensibles
variable "api_token" {
  description = "API token"
  type        = string
  sensitive   = true
}

# ❌ Incorrecto - No hardcodear secretos
resource "aws_instance" "example" {
  user_data = "#!/bin/bash\necho 'secret-key-here'"
}
```

#### En Archivos de Configuración

```hcl
# ✅ Correcto - Usar variables
cloudflare_api_token = var.cloudflare_api_token

# ❌ Incorrecto - Hardcodear secretos
cloudflare_api_token = "actual-token-here"
```

## 🛡️ Configuración de AWS

### IAM - Principio de Menor Privilegio

#### Usuario de Terraform

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::fascinante-digital-terraform-state",
        "arn:aws:s3:::fascinante-digital-terraform-state/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:*:table/fascinante-digital-terraform-locks"
    }
  ]
}
```

#### Roles de Servicio

```hcl
# ✅ Correcto - Rol con permisos mínimos
resource "aws_iam_role" "lambda_execution" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Política con permisos específicos
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-policy"
  role = aws_iam_role.lambda_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}
```

### S3 - Seguridad de Buckets

#### Configuración Segura

```hcl
# ✅ Correcto - Bucket con configuración segura
resource "aws_s3_bucket" "example" {
  bucket = "fascinante-secure-bucket"
}

# Bloqueo de acceso público
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Cifrado
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versionado
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

#### Política de Bucket

```hcl
# Política restrictiva para bucket de estado
resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyInsecureConnections"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
```

## 🔒 Configuración de Cloudflare

### API Token

#### Permisos Mínimos

```bash
# Crear token con permisos específicos
curl -X POST "https://api.cloudflare.com/client/v4/user/tokens" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "Terraform DNS Management",
    "policies": [
      {
        "effect": "allow",
        "permission_groups": [
          {
            "id": "dns_records:edit",
            "name": "DNS:Edit"
          }
        ],
        "resources": {
          "com.cloudflare.api.account.zone": {
            "key": "ZONE_ID",
            "attributes": {
              "name": "fascinantedigital.com"
            }
          }
        }
      }
    ]
  }'
```

### Configuración DNS

#### Registros Seguros

```hcl
# ✅ Correcto - Registros con proxy habilitado
resource "cloudflare_record" "secure" {
  zone_id = data.cloudflare_zone.main.id
  name    = "api"
  value   = "192.0.2.1"
  type    = "A"
  proxied = true  # Protección DDoS y CDN
}

# ❌ Incorrecto - Registros sin proxy
resource "cloudflare_record" "insecure" {
  zone_id = data.cloudflare_zone.main.id
  name    = "api"
  value   = "192.0.2.1"
  type    = "A"
  proxied = false  # Sin protección
}
```

## 🚨 Prevención de Cambios Manuales

### Bloqueo de Recursos

```hcl
# ✅ Correcto - Bloquear eliminación de recursos críticos
resource "aws_s3_bucket" "terraform_state" {
  bucket = "fascinante-digital-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "fascinante-digital-terraform-locks"

  lifecycle {
    prevent_destroy = true
  }
}
```

### Validaciones

```hcl
# Validar configuración crítica
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  # Validar que el bucket no sea público
  lifecycle {
    precondition {
      condition     = !var.public_access
      error_message = "Buckets cannot be public for security reasons."
    }
  }
}
```

## 🔍 Monitoreo y Auditoría

### CloudTrail

```hcl
# Habilitar CloudTrail para auditoría
resource "aws_cloudtrail" "terraform_audit" {
  name                          = "terraform-audit-trail"
  s3_bucket_name               = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail        = true

  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.terraform_state.arn}/*"]
    }
  }
}
```

### Config Rules

```hcl
# Regla para verificar cifrado de S3
resource "aws_config_config_rule" "s3_encryption" {
  name = "s3-bucket-encryption"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}
```

## 🛠️ Herramientas de Seguridad

### TFSec

```bash
# Instalar TFSec
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Ejecutar escaneo
tfsec --config-file tools/tfsec-excludes.yml

# Ejecutar con formato JSON
tfsec --format json --out tfsec-results.json
```

### Checkov

```bash
# Instalar Checkov
pip install checkov

# Ejecutar escaneo
checkov -d . --framework terraform

# Ejecutar con configuración personalizada
checkov -d . --config-file .checkov.yml
```

### OWASP ZAP

```bash
# Escanear APIs expuestas
docker run -t owasp/zap2docker-stable zap-baseline.py -t https://api.fascinantedigital.com
```

## 📋 Checklist de Seguridad

### Antes de Cada Deploy

- [ ] **Secretos**: Verificar que no hay secretos hardcodeados
- [ ] **Permisos**: Revisar permisos de IAM
- [ ] **Cifrado**: Verificar que todos los recursos están cifrados
- [ ] ] **Acceso público**: Verificar que no hay recursos públicos innecesarios
- [ ] **TFSec**: Ejecutar escaneo de seguridad
- [ ] **Plan**: Revisar plan de Terraform antes de aplicar

### Semanalmente

- [ ] **Rotación**: Rotar secretos y tokens
- [ ] **Auditoría**: Revisar logs de CloudTrail
- [ ] **Actualizaciones**: Actualizar providers y módulos
- [ ] **Vulnerabilidades**: Escanear dependencias

### Mensualmente

- [ ] **Revisión**: Revisar políticas de seguridad
- [ ] **Entrenamiento**: Actualizar documentación de seguridad
- [ ] **Pruebas**: Ejecutar pruebas de penetración
- [ ] **Backup**: Verificar backups de estado

## 🚨 Respuesta a Incidentes

### Compromiso de Secretos

1. **Inmediatamente**: Rotar todos los secretos comprometidos
2. **Investigar**: Revisar logs para determinar alcance
3. **Notificar**: Informar al equipo de seguridad
4. **Documentar**: Registrar el incidente
5. **Prevenir**: Implementar medidas preventivas

### Acceso No Autorizado

1. **Bloquear**: Revocar acceso inmediatamente
2. **Investigar**: Determinar qué recursos fueron afectados
3. **Restaurar**: Restaurar desde backups si es necesario
4. **Notificar**: Informar a stakeholders
5. **Mejorar**: Fortalecer controles de acceso

## 📞 Contacto de Seguridad

- **Email**: [info@fascinantedigital.com](mailto:info@fascinantedigital.com)
- **Slack**: #security-alerts
- **GitHub**: @fascinante-digital/security-team

---

**Recuerda**: La seguridad es responsabilidad de todos. Si ves algo sospechoso, repórtalo inmediatamente.
