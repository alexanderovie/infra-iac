# AWS SES Provider Module

Este módulo configura Amazon SES (Simple Email Service) para el envío de emails desde dominios de Fascinante Digital.

## Características

- **Identidad de dominio**: Verificación de propiedad del dominio
- **DKIM**: Firma digital para autenticación de emails
- **MAIL FROM**: Configuración de dominio de envío
- **DNS automático**: Creación automática de registros DNS (opcional)
- **Verificación automática**: Verificación de dominio y DKIM

## Uso

### Variables requeridas

```hcl
domain      = "fascinantedigital.com"
environment = "prod"
aws_region  = "us-east-1"
```

### Ejemplo básico

```hcl
module "ses" {
  source = "../../providers/aws-ses"

  domain      = "fascinantedigital.com"
  environment = "prod"
  aws_region  = "us-east-1"
}
```

### Ejemplo con MAIL FROM

```hcl
module "ses" {
  source = "../../providers/aws-ses"

  domain                = "fascinantedigital.com"
  environment           = "prod"
  aws_region            = "us-east-1"
  mail_from_subdomain   = "mail"
  route53_zone_id       = "Z1234567890" # Opcional para DNS automático
}
```

## Outputs

- `domain_identity_arn`: ARN de la identidad del dominio
- `verification_txt_name/value`: Registro TXT para verificación
- `dkim_tokens`: Tokens DKIM generados
- `dkim_cname_records`: Registros CNAME para DKIM
- `mail_from_domain`: Dominio MAIL FROM configurado
- `domain_verified`: Estado de verificación del dominio

## Configuración DNS Manual

Si no proporcionas `route53_zone_id`, necesitarás crear manualmente estos registros DNS:

### 1. Verificación de dominio

```
Tipo: TXT
Nombre: _amazonses.fascinantedigital.com
Valor: [verification_token]
```

### 2. DKIM (3 registros CNAME)

```
Tipo: CNAME
Nombre: [token1]._domainkey.fascinantedigital.com
Valor: [token1].dkim.amazonses.com

Tipo: CNAME
Nombre: [token2]._domainkey.fascinantedigital.com
Valor: [token2].dkim.amazonses.com

Tipo: CNAME
Nombre: [token3]._domainkey.fascinantedigital.com
Valor: [token3].dkim.amazonses.com
```

### 3. MAIL FROM (si se configura)

```
Tipo: MX
Nombre: mail.fascinantedigital.com
Valor: 10 feedback-smtp.us-east-1.amazonses.com

Tipo: TXT
Nombre: mail.fascinantedigital.com
Valor: v=spf1 include:amazonses.com ~all
```

## Límites de SES

- **Sandbox mode**: Por defecto, solo puedes enviar a emails verificados
- **Production access**: Solicita acceso de producción para enviar a cualquier email
- **Sending limits**: 200 emails/día en sandbox, más en producción
- **Rate limits**: 14 emails/segundo en sandbox

## ⚠️ Consideraciones

- **Región**: SES solo está disponible en ciertas regiones (us-east-1, us-west-2, eu-west-1)
- **Verificación**: El dominio debe estar verificado antes de enviar emails
- **DKIM**: Requiere 3 registros CNAME para funcionar correctamente
- **MAIL FROM**: Mejora la reputación del dominio para envío
- **SPF**: Incluye amazonses.com en tu registro SPF existente
