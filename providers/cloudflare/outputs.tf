output "zone_id" {
  description = "Cloudflare Zone ID"
  value       = data.cloudflare_zone.main.id
}

output "zone_name" {
  description = "Cloudflare Zone Name"
  value       = data.cloudflare_zone.main.name
}

output "a_record_ids" {
  description = "IDs of A records"
  value       = { for k, v in cloudflare_dns_record.a_records : k => v.id }
}

output "cname_record_ids" {
  description = "IDs of CNAME records"
  value       = { for k, v in cloudflare_dns_record.cname_records : k => v.id }
}

output "txt_record_ids" {
  description = "IDs of TXT records"
  value       = { for k, v in cloudflare_dns_record.txt_records : k => v.id }
}

output "mx_record_ids" {
  description = "IDs of MX records"
  value       = { for k, v in cloudflare_dns_record.mx_records : k => v.id }
}

output "all_records" {
  description = "Flattened map of all managed records"
  value = merge(
    { for k, v in cloudflare_dns_record.a_records : "a:${k}" => {
      id      = v.id
      name    = v.name
      content = v.content
      type    = v.type
      }
    },
    { for k, v in cloudflare_dns_record.cname_records : "cname:${k}" => {
      id      = v.id
      name    = v.name
      content = v.content
      type    = v.type
      }
    },
    { for k, v in cloudflare_dns_record.txt_records : "txt:${k}" => {
      id      = v.id
      name    = v.name
      content = v.content
      type    = v.type
      }
    },
    { for k, v in cloudflare_dns_record.mx_records : "mx:${k}" => {
      id      = v.id
      name    = v.name
      content = v.content
      type    = v.type
      }
    },
    var.create_spf_record ? {
      "txt:spf" = {
        id      = cloudflare_dns_record.spf_record[0].id
        name    = cloudflare_dns_record.spf_record[0].name
        content = cloudflare_dns_record.spf_record[0].content
        type    = cloudflare_dns_record.spf_record[0].type
      }
    } : {},
    var.create_dmarc_record ? {
      "txt:dmarc" = {
        id      = cloudflare_dns_record.dmarc_record[0].id
        name    = cloudflare_dns_record.dmarc_record[0].name
        content = cloudflare_dns_record.dmarc_record[0].content
        type    = cloudflare_dns_record.dmarc_record[0].type
      }
    } : {},
    { for k, v in cloudflare_dns_record.dkim_records : "cname:dkim:${k}" => {
      id      = v.id
      name    = v.name
      content = v.content
      type    = v.type
      }
    }
  )
}
