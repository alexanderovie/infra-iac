#!/usr/bin/env bash
set -euo pipefail

# 🚀 Setup automático de backend para Terraform/OpenTofu
# Crea bucket S3 + tabla DynamoDB para state/lock

AWS_REGION="us-east-1"
BUCKET_NAME="fascinante-tfstate-dev"
DYNAMO_TABLE="fascinante-tfstate-locks"

echo "=== Creando bucket S3 ($BUCKET_NAME) en región $AWS_REGION ==="
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "✅ Bucket ya existe: $BUCKET_NAME"
else
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION"
  else
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION"
  fi
  echo "✅ Bucket creado: $BUCKET_NAME"
fi

echo "=== Creando tabla DynamoDB ($DYNAMO_TABLE) ==="
if aws dynamodb describe-table --table-name "$DYNAMO_TABLE" --region "$AWS_REGION" >/dev/null 2>&1; then
  echo "✅ Tabla ya existe: $DYNAMO_TABLE"
else
  aws dynamodb create-table \
    --table-name "$DYNAMO_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$AWS_REGION"
  echo "✅ Tabla creada: $DYNAMO_TABLE"
fi

echo "🎉 Backend listo: S3=$BUCKET_NAME | DynamoDB=$DYNAMO_TABLE"
