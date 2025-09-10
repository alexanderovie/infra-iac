# dev

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | >= 1.10 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement_cloudflare) | ~> 5.5  |
| <a name="requirement_vercel"></a> [vercel](#requirement_vercel)             | ~> 1.0  |

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_cloudflare"></a> [cloudflare](#provider_cloudflare) | 5.9.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [cloudflare_dns_record.api](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)          | resource    |
| [cloudflare_dns_record.mx](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)           | resource    |
| [cloudflare_dns_record.root](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)         | resource    |
| [cloudflare_dns_record.stage](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)        | resource    |
| [cloudflare_dns_record.verification](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource    |
| [cloudflare_dns_record.www](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)          | resource    |
| [cloudflare_zone.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone)                  | data source |

## Inputs

| Name                                                                                    | Description                                                  | Type     | Default                   | Required |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------ | -------- | ------------------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                         | AWS region for resources                                     | `string` | `"us-east-1"`             |    no    |
| <a name="input_cloudflare_api_key"></a> [cloudflare_api_key](#input_cloudflare_api_key) | Cloudflare API key                                           | `string` | n/a                       |   yes    |
| <a name="input_cloudflare_email"></a> [cloudflare_email](#input_cloudflare_email)       | Cloudflare account email                                     | `string` | n/a                       |   yes    |
| <a name="input_dev_ip"></a> [dev_ip](#input_dev_ip)                                     | Development environment IP address                           | `string` | `"192.0.2.2"`             |    no    |
| <a name="input_domain"></a> [domain](#input_domain)                                     | Domain name to manage                                        | `string` | `"fascinantedigital.com"` |    no    |
| <a name="input_main_ip"></a> [main_ip](#input_main_ip)                                  | Main IP address for A records                                | `string` | `"192.0.2.1"`             |    no    |
| <a name="input_route53_zone_id"></a> [route53_zone_id](#input_route53_zone_id)          | Route53 zone ID for automatic DNS record creation (optional) | `string` | `null`                    |    no    |
| <a name="input_vercel_api_token"></a> [vercel_api_token](#input_vercel_api_token)       | Vercel API token                                             | `string` | n/a                       |   yes    |
| <a name="input_vercel_team_id"></a> [vercel_team_id](#input_vercel_team_id)             | Vercel team ID                                               | `string` | n/a                       |   yes    |

## Outputs

| Name                                                                                      | Description                     |
| ----------------------------------------------------------------------------------------- | ------------------------------- |
| <a name="output_dns_records"></a> [dns_records](#output_dns_records)                      | SÚPER-ÉLITE DNS records created |
| <a name="output_staging_dns_record"></a> [staging_dns_record](#output_staging_dns_record) | Staging subdomain DNS record    |
| <a name="output_zone_id"></a> [zone_id](#output_zone_id)                                  | Cloudflare zone ID              |
| <a name="output_zone_name"></a> [zone_name](#output_zone_name)                            | Cloudflare zone name            |

<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | >= 1.9  |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement_cloudflare) | ~> 5.5  |
| <a name="requirement_vercel"></a> [vercel](#requirement_vercel)             | ~> 1.0  |

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_cloudflare"></a> [cloudflare](#provider_cloudflare) | 5.9.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                                   | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [cloudflare_dns_record.api](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)            | resource    |
| [cloudflare_dns_record.mx](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)             | resource    |
| [cloudflare_dns_record.root](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)           | resource    |
| [cloudflare_dns_record.stage](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)          | resource    |
| [cloudflare_dns_record.verification](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)   | resource    |
| [cloudflare_dns_record.www](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record)            | resource    |
| [cloudflare_ruleset.redirect_www_to_root](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset) | resource    |
| [cloudflare_zone.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone)                    | data source |

## Inputs

| Name                                                                                          | Description                                                  | Type     | Default                   | Required |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | -------- | ------------------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                               | AWS region for resources                                     | `string` | `"us-east-1"`             |    no    |
| <a name="input_cloudflare_api_token"></a> [cloudflare_api_token](#input_cloudflare_api_token) | Cloudflare API token                                         | `string` | n/a                       |   yes    |
| <a name="input_cloudflare_email"></a> [cloudflare_email](#input_cloudflare_email)             | Cloudflare account email                                     | `string` | n/a                       |   yes    |
| <a name="input_dev_ip"></a> [dev_ip](#input_dev_ip)                                           | Development environment IP address                           | `string` | `"192.0.2.2"`             |    no    |
| <a name="input_domain"></a> [domain](#input_domain)                                           | Domain name to manage                                        | `string` | `"fascinantedigital.com"` |    no    |
| <a name="input_main_ip"></a> [main_ip](#input_main_ip)                                        | Main IP address for A records                                | `string` | `"192.0.2.1"`             |    no    |
| <a name="input_route53_zone_id"></a> [route53_zone_id](#input_route53_zone_id)                | Route53 zone ID for automatic DNS record creation (optional) | `string` | `null`                    |    no    |
| <a name="input_vercel_api_token"></a> [vercel_api_token](#input_vercel_api_token)             | Vercel API token                                             | `string` | n/a                       |   yes    |
| <a name="input_vercel_team_id"></a> [vercel_team_id](#input_vercel_team_id)                   | Vercel team ID                                               | `string` | n/a                       |   yes    |

## Outputs

| Name                                                                                      | Description                     |
| ----------------------------------------------------------------------------------------- | ------------------------------- |
| <a name="output_dns_records"></a> [dns_records](#output_dns_records)                      | SÚPER-ÉLITE DNS records created |
| <a name="output_staging_dns_record"></a> [staging_dns_record](#output_staging_dns_record) | Staging subdomain DNS record    |
| <a name="output_zone_id"></a> [zone_id](#output_zone_id)                                  | Cloudflare zone ID              |
| <a name="output_zone_name"></a> [zone_name](#output_zone_name)                            | Cloudflare zone name            |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
