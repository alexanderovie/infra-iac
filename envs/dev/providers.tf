provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Project     = "Fascinante Digital"
      ManagedBy   = "Terraform"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
