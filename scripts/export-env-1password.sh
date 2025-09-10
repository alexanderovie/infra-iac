#!/usr/bin/env bash
set -euo pipefail
VAULT="Fascinante Digital Infrastructure"

op_read () { op read "$1" | tr -d '\r'; }

# AWS
AWS_ACCESS_KEY_ID="$(op_read "op://$VAULT/AWS – Prod/Access Key ID")"
export AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY="$(op_read "op://$VAULT/AWS – Prod/Secret Access Key")"
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

# Cloudflare
CLOUDFLARE_API_TOKEN="$(op_read "op://$VAULT/Cloudflare – Prod/API Token")"
export CLOUDFLARE_API_TOKEN

# GitHub
GITHUB_TOKEN="$(op_read "op://$VAULT/GitHub – PAT/Token")"
export GITHUB_TOKEN

# Vercel
VERCEL_TOKEN="$(op_read "op://$VAULT/Vercel – Prod/API Token")"
export VERCEL_TOKEN

# Supabase
SUPABASE_SERVICE_ROLE_KEY="$(op_read "op://$VAULT/Supabase – Service Role/Service Role Key")"
export SUPABASE_SERVICE_ROLE_KEY
NEXT_PUBLIC_SUPABASE_URL="$(op_read "op://$VAULT/Supabase – Service Role/Project URL")"
export NEXT_PUBLIC_SUPABASE_URL

# Stripe
STRIPE_SECRET_KEY="$(op_read "op://$VAULT/Stripe – Prod/Secret Key")"
export STRIPE_SECRET_KEY

# Resend
RESEND_API_KEY="$(op_read "op://$VAULT/Resend – Prod/API Key")"
export RESEND_API_KEY

# DataForSEO
DATAFORSEO_LOGIN="$(op_read "op://$VAULT/DataForSEO – Prod/Login")"
export DATAFORSEO_LOGIN
DATAFORSEO_PASSWORD="$(op_read "op://$VAULT/DataForSEO – Prod/Password")"
export DATAFORSEO_PASSWORD

# BrightLocal
BRIGHTLOCAL_API_KEY="$(op_read "op://$VAULT/BrightLocal – Prod/API Key")"
export BRIGHTLOCAL_API_KEY
