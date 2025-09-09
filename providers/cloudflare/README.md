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
