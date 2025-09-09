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
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.domain_verification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.mail_from_mx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.mail_from_spf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification) | resource |
| [aws_ses_domain_mail_from.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for SES | `string` | `"us-east-1"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name for SES identity | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, stage, prod) | `string` | n/a | yes |
| <a name="input_mail_from_subdomain"></a> [mail\_from\_subdomain](#input\_mail\_from\_subdomain) | MAIL FROM subdomain (e.g., 'mail' for mail.fascinantedigital.com) | `string` | `null` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID for automatic DNS record creation (optional) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dkim_cname_records"></a> [dkim\_cname\_records](#output\_dkim\_cname\_records) | CNAME records needed for DKIM verification |
| <a name="output_dkim_tokens"></a> [dkim\_tokens](#output\_dkim\_tokens) | DKIM tokens for the domain |
| <a name="output_dkim_verified"></a> [dkim\_verified](#output\_dkim\_verified) | Whether DKIM is verified (only available if Route53 zone ID is provided) |
| <a name="output_domain_identity_arn"></a> [domain\_identity\_arn](#output\_domain\_identity\_arn) | ARN of the SES domain identity |
| <a name="output_domain_identity_verification_token"></a> [domain\_identity\_verification\_token](#output\_domain\_identity\_verification\_token) | Verification token for domain identity |
| <a name="output_domain_verified"></a> [domain\_verified](#output\_domain\_verified) | Whether the domain is verified (only available if Route53 zone ID is provided) |
| <a name="output_mail_from_domain"></a> [mail\_from\_domain](#output\_mail\_from\_domain) | MAIL FROM domain |
| <a name="output_mail_from_mx_record"></a> [mail\_from\_mx\_record](#output\_mail\_from\_mx\_record) | MX record for MAIL FROM domain |
| <a name="output_mail_from_spf_record"></a> [mail\_from\_spf\_record](#output\_mail\_from\_spf\_record) | SPF record for MAIL FROM domain |
| <a name="output_verification_txt_name"></a> [verification\_txt\_name](#output\_verification\_txt\_name) | Name for the TXT record to verify domain ownership |
| <a name="output_verification_txt_value"></a> [verification\_txt\_value](#output\_verification\_txt\_value) | Value for the TXT record to verify domain ownership |
<!-- END_TF_DOCS -->
