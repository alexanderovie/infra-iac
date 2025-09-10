#!/bin/bash
# SÚPER-ÉLITE Environment Variables for Fascinante Digital Infrastructure

# ==== ⚡️ Configuración AWS ====
export AWS_ACCESS_KEY_ID="AKIA2UC3ERFFCEQYPT2R"  # pragma: allowlist secret
export AWS_SECRET_ACCESS_KEY="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"  # pragma: allowlist secret
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"

# ==== ⚡️ Configuración Cloudflare ====
export CLOUDFLARE_API_KEY="b361ae69d2ab1930639a666d399cd0253c2d2"  # pragma: allowlist secret
export CLOUDFLARE_EMAIL="info@fascinantedigital.com"

# ==== ⚡️ Configuración GitHub ====
export GITHUB_TOKEN="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"  # pragma: allowlist secret
export GITHUB_OWNER="alexanderovie"

# ==== ⚡️ Configuración Vercel ====
export VERCEL_TOKEN="O3VHygNiBrOfXfjvCUYjTiPF"
export VERCEL_TEAM_ID="alexanderoviedo"

# ==== ⚡️ Terraform Variables ====
export TF_VAR_cloudflare_api_key="$CLOUDFLARE_API_KEY"
export TF_VAR_cloudflare_email="$CLOUDFLARE_EMAIL"
export TF_VAR_vercel_api_token="$VERCEL_TOKEN"
export TF_VAR_vercel_team_id="$VERCEL_TEAM_ID"
export TF_VAR_github_token="$GITHUB_TOKEN"
export TF_VAR_github_owner="$GITHUB_OWNER"

echo "✅ SÚPER-ÉLITE Environment variables exported successfully!"
echo "🔧 Available variables:"
echo "   - AWS: $AWS_ACCESS_KEY_ID"
echo "   - Cloudflare: $CLOUDFLARE_EMAIL"
echo "   - GitHub: $GITHUB_OWNER"
echo "   - Vercel: $VERCEL_TEAM_ID"

# ==== ⚡️ Cloudflare Zone ID ====
export ZONE_ID="6d7328e7f3edb975ef1f52cdb29178b7"

echo "   - Zone ID: $ZONE_ID"
