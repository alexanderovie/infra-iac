# Cloudflare Provider Module

Este módulo gestiona los registros DNS y la configuración de dominios en Cloudflare para Fascinante Digital.

## Características

- **Gestión de registros DNS**: A, CNAME, TXT, MX
- **Configuración flexible**: TTL, proxy, comentarios
- **Soporte para múltiples entornos**: dev, stage, prod
- **Tags automáticos**: Para organización y costos

## Uso

### Variables requeridas

```hcl
cloudflare_api_token = "your-api-token"
domain              = "fascinantedigital.com"
environment         = "prod"
```

### Ejemplo de configuración

```hcl
module "cloudflare" {
  source = "../../providers/cloudflare"

  cloudflare_api_token = var.cloudflare_api_token
  domain              = "fascinantedigital.com"
  environment         = "prod"

  a_records = {
    "@" = {
      value   = "192.0.2.1"
      proxied = true
      comment = "Main domain A record"
    }
    "www" = {
      value   = "192.0.2.1"
      proxied = true
      comment = "WWW subdomain"
    }
  }

  cname_records = {
    "api" = {
      value   = "api.fascinantedigital.com"
      proxied = false
      comment = "API subdomain"
    }
  }

  txt_records = {
    "@" = {
      value   = "v=spf1 include:_spf.google.com ~all"
      comment = "SPF record"
    }
  }

  mx_records = {
    "@" = {
      value    = "aspmx.l.google.com"
      priority = 1
      comment  = "Google Workspace MX"
    }
  }
}
```

## Outputs

- `zone_id`: ID de la zona de Cloudflare
- `zone_name`: Nombre de la zona
- `a_record_ids`: IDs de los registros A
- `cname_record_ids`: IDs de los registros CNAME
- `txt_record_ids`: IDs de los registros TXT
- `mx_record_ids`: IDs de los registros MX
- `all_records`: Todos los registros creados

## Configuración de TTL

- `ttl = 1`: TTL automático (recomendado para registros con proxy)
- `ttl = 300`: 5 minutos
- `ttl = 3600`: 1 hora
- `ttl = 86400`: 24 horas

## Proxy de Cloudflare

- `proxied = true`: Activa el proxy de Cloudflare (CDN, DDoS protection)
- `proxied = false`: Desactiva el proxy (tráfico directo)

## ⚠️ Consideraciones

- **API Token**: Usa tokens con permisos mínimos necesarios
- **TTL**: Los registros con proxy deben usar TTL automático
- **Verificación**: Algunos registros TXT requieren verificación manual
- **Límites**: Cloudflare tiene límites en el número de registros por zona

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.a_records](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.cname_records](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.dkim_records](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.dmarc_record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.mx_records](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.spf_record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.txt_records](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_zone.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | Map of A records to create | <pre>map(object({<br/>    value   = string<br/>    ttl     = optional(number, 1) # 1 = auto TTL<br/>    proxied = optional(bool, false)<br/>    comment = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token | `string` | n/a | yes |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | Map of CNAME records to create | <pre>map(object({<br/>    value   = string<br/>    ttl     = optional(number, 1) # 1 = auto TTL<br/>    proxied = optional(bool, false)<br/>    comment = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_create_dmarc_record"></a> [create\_dmarc\_record](#input\_create\_dmarc\_record) | Whether to create DMARC record | `bool` | `false` | no |
| <a name="input_create_spf_record"></a> [create\_spf\_record](#input\_create\_spf\_record) | Whether to create SPF record | `bool` | `false` | no |
| <a name="input_dkim_tokens"></a> [dkim\_tokens](#input\_dkim\_tokens) | Map of DKIM tokens from SES | `map(string)` | `{}` | no |
| <a name="input_dmarc_value"></a> [dmarc\_value](#input\_dmarc\_value) | DMARC record value | `string` | `"v=DMARC1; p=quarantine; rua=mailto:dmarc@fascinantedigital.com"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name to manage | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, stage, prod) | `string` | n/a | yes |
| <a name="input_mx_records"></a> [mx\_records](#input\_mx\_records) | Map of MX records to create | <pre>map(object({<br/>    value    = string<br/>    priority = number<br/>    ttl      = optional(number, 1) # 1 = auto TTL<br/>    comment  = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_spf_value"></a> [spf\_value](#input\_spf\_value) | SPF record value | `string` | `"v=spf1 include:_spf.google.com ~all"` | no |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | Map of TXT records to create | <pre>map(object({<br/>    value   = string<br/>    ttl     = optional(number, 1) # 1 = auto TTL<br/>    comment = optional(string, "")<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_a_record_ids"></a> [a\_record\_ids](#output\_a\_record\_ids) | IDs of A records |
| <a name="output_all_records"></a> [all\_records](#output\_all\_records) | Flattened map of all managed records |
| <a name="output_cname_record_ids"></a> [cname\_record\_ids](#output\_cname\_record\_ids) | IDs of CNAME records |
| <a name="output_mx_record_ids"></a> [mx\_record\_ids](#output\_mx\_record\_ids) | IDs of MX records |
| <a name="output_txt_record_ids"></a> [txt\_record\_ids](#output\_txt\_record\_ids) | IDs of TXT records |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Cloudflare Zone ID |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Cloudflare Zone Name |
<!-- END_TF_DOCS -->
