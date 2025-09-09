# Bootstrap Module

Este módulo crea la infraestructura base necesaria para el manejo de estado de Terraform en Fascinante Digital.

## ¿Qué crea este módulo?

- **Bucket S3**: Para almacenar los archivos de estado de Terraform
  - Versionado habilitado
  - Cifrado AES256
  - Bloqueo de acceso público
- **Tabla DynamoDB**: Para el bloqueo de estado (state locking)
  - Modo de facturación bajo demanda
  - Clave primaria: LockID

## Uso

### 1. Configurar variables

Crea un archivo `terraform.tfvars`:

```hcl
aws_region           = "us-east-1"
bucket_name          = "fascinante-digital-terraform-state"
dynamodb_table_name  = "fascinante-digital-terraform-locks"
```

### 2. Inicializar y aplicar

```bash
cd bootstrap/
terraform init
terraform plan
terraform apply
```

### 3. Guardar outputs

Después de la aplicación exitosa, guarda los outputs en un archivo para referencia futura:

```bash
terraform output -json > outputs.json
```

## ⚠️ IMPORTANTE

- **Ejecuta este módulo SOLO UNA VEZ**
- **NO elimines estos recursos** - contienen el estado de toda tu infraestructura
- **Asegúrate de tener permisos de AWS** configurados correctamente
- **Usa un perfil de AWS** o variables de entorno para autenticación

## Próximos pasos

Una vez completado el bootstrap, puedes proceder a configurar los entornos en `../envs/`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.80 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for the infrastructure | `string` | `"us-east-1"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket for Terraform state | `string` | `"fascinante-digital-terraform-state"` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | Name of the DynamoDB table for state locking | `string` | `"fascinante-digital-terraform-locks"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS region used for the infrastructure |
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | ARN of the DynamoDB table for state locking |
| <a name="output_dynamodb_table_name"></a> [dynamodb\_table\_name](#output\_dynamodb\_table\_name) | Name of the DynamoDB table for state locking |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket for Terraform state |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of the S3 bucket for Terraform state |
<!-- END_TF_DOCS -->
