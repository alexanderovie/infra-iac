# prod

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.80 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.5 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_core"></a> [aws\_core](#module\_aws\_core) | ../../providers/aws-core | n/a |
| <a name="module_cloudflare"></a> [cloudflare](#module\_cloudflare) | ../../providers/cloudflare | n/a |
| <a name="module_ses"></a> [ses](#module\_ses) | ../../providers/aws-ses | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for resources | `string` | `"us-east-1"` | no |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name to manage | `string` | `"fascinantedigital.com"` | no |
| <a name="input_main_ip"></a> [main\_ip](#input\_main\_ip) | Main IP address for A records | `string` | `"192.0.2.1"` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone ID for automatic DNS record creation (optional) | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
