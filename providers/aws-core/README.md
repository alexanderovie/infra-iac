# AWS Core Provider Module

Este módulo proporciona recursos básicos de AWS para Fascinante Digital: buckets S3 genéricos, colas SQS y roles IAM básicos.

## Características

- **Buckets S3**: Con versionado, cifrado y bloqueo de acceso público
- **Colas SQS**: Con soporte para dead letter queues
- **Roles IAM**: Roles básicos con políticas personalizables
- **Configuración flexible**: Todos los parámetros son configurables

## Uso

### Variables requeridas

```hcl
environment = "prod"
aws_region  = "us-east-1"
```

### Ejemplo básico

```hcl
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = "us-east-1"
}
```

### Ejemplo con buckets S3

```hcl
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = "us-east-1"

  s3_buckets = {
    "app-assets" = {
      bucket_name          = "fascinante-app-assets"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Application assets"
        Type    = "Static files"
      }
    }
    "backups" = {
      bucket_name          = "fascinante-backups"
      versioning_enabled   = true
      encryption_algorithm = "AES256"
      tags = {
        Purpose = "Database backups"
        Type    = "Backup storage"
      }
    }
  }
}
```

### Ejemplo con colas SQS

```hcl
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = "us-east-1"

  sqs_queues = {
    "email-queue" = {
      queue_name                = "fascinante-email-queue"
      delay_seconds             = 0
      max_message_size          = 262144
      message_retention_seconds = 1209600
      visibility_timeout_seconds = 30
      dead_letter_queue = {
        max_receive_count = 3
      }
      tags = {
        Purpose = "Email processing"
        Type    = "Message queue"
      }
    }
  }
}
```

### Ejemplo con roles IAM

```hcl
module "aws_core" {
  source = "../../providers/aws-core"

  environment = "prod"
  aws_region  = "us-east-1"

  iam_roles = {
    "lambda-execution" = {
      role_name           = "fascinante-lambda-execution"
      assume_role_service = "lambda.amazonaws.com"
      policy_document = jsonencode({
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
      tags = {
        Purpose = "Lambda execution"
        Type    = "Service role"
      }
    }
  }
}
```

## Outputs

- `s3_buckets`: Información de buckets S3 creados
- `sqs_queues`: Información de colas SQS creadas
- `dead_letter_queues`: Información de dead letter queues
- `iam_roles`: Información de roles IAM creados

## Configuración de S3

### Algoritmos de cifrado

- `AES256`: Cifrado AES-256 (recomendado)
- `aws:kms`: Cifrado con KMS (requiere configuración adicional)

### Versionado

- `versioning_enabled = true`: Habilita versionado (recomendado)
- `versioning_enabled = false`: Deshabilita versionado

## Configuración de SQS

### Parámetros importantes

- `delay_seconds`: Retraso antes de que el mensaje esté disponible
- `max_message_size`: Tamaño máximo del mensaje (bytes)
- `message_retention_seconds`: Tiempo de retención (máximo 14 días)
- `visibility_timeout_seconds`: Tiempo de visibilidad del mensaje

### Dead Letter Queues

- `max_receive_count`: Número máximo de intentos antes de enviar a DLQ
- Se crea automáticamente una cola DLQ con sufijo `-dlq`

## Configuración de IAM

### Servicios soportados

- `lambda.amazonaws.com`: Para funciones Lambda
- `ec2.amazonaws.com`: Para instancias EC2
- `ecs-tasks.amazonaws.com`: Para tareas ECS
- `s3.amazonaws.com`: Para buckets S3

### Políticas

- Usa `jsonencode()` para políticas complejas
- Sigue el principio de menor privilegio
- Incluye solo los permisos necesarios

## ⚠️ Consideraciones

- **Nombres únicos**: Los nombres de buckets S3 deben ser únicos globalmente
- **Costos**: S3 y SQS tienen costos asociados
- **Límites**: AWS tiene límites en el número de recursos por región
- **Seguridad**: Todos los buckets tienen acceso público bloqueado por defecto
- **Backup**: Considera políticas de ciclo de vida para buckets S3
