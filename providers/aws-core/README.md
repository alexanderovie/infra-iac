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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.basic_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.basic_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.generic_buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.generic_buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.generic_buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.generic_buckets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sqs_queue.dead_letter_queues](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.generic_queues](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_redrive_policy.dead_letter_queues](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_redrive_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for resources | `string` | `"us-east-1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, stage, prod) | `string` | n/a | yes |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | Map of IAM roles to create | <pre>map(object({<br/>    role_name           = string<br/>    assume_role_service = string<br/>    policy_document     = string<br/>    tags                = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_s3_buckets"></a> [s3\_buckets](#input\_s3\_buckets) | Map of S3 buckets to create | <pre>map(object({<br/>    bucket_name          = string<br/>    versioning_enabled   = optional(bool, true)<br/>    encryption_algorithm = optional(string, "AES256")<br/>    bucket_key_enabled   = optional(bool, false)<br/>    tags                 = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_sqs_queues"></a> [sqs\_queues](#input\_sqs\_queues) | Map of SQS queues to create | <pre>map(object({<br/>    queue_name                 = string<br/>    delay_seconds              = optional(number, 0)<br/>    max_message_size           = optional(number, 262144)<br/>    message_retention_seconds  = optional(number, 1209600)<br/>    receive_wait_time_seconds  = optional(number, 0)<br/>    visibility_timeout_seconds = optional(number, 30)<br/>    dead_letter_queue = optional(object({<br/>      max_receive_count = number<br/>    }), null)<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dead_letter_queues"></a> [dead\_letter\_queues](#output\_dead\_letter\_queues) | Map of dead letter queue information |
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | Map of IAM role information |
| <a name="output_s3_buckets"></a> [s3\_buckets](#output\_s3\_buckets) | Map of S3 bucket information |
| <a name="output_sqs_queues"></a> [sqs\_queues](#output\_sqs\_queues) | Map of SQS queue information |
<!-- END_TF_DOCS -->
