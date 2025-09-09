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
