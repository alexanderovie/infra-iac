#!/usr/bin/env bash
set -euo pipefail
VAULT="Fascinante Digital Infrastructure"

need_item () {
  local title="$1"; shift
  if op item get "$title" --vault "$VAULT" >/dev/null 2>&1; then
    echo "✓ $title ya existe"
  else
    echo "→ creando $title"
    op item create --vault "$VAULT" --category "API Credential" --title "$title" "$@"
  fi
}

need_item "AWS - Prod" "Access Key ID[text]=REEMPLAZA" "Secret Access Key[concealed]=REEMPLAZA"
need_item "Cloudflare - Prod" "API Token[concealed]=REEMPLAZA"
need_item "GitHub - PAT" "Token[concealed]=REEMPLAZA"
need_item "Vercel - Prod" "API Token[concealed]=REEMPLAZA"
need_item "Supabase - Service Role" "Project URL[text]=REEMPLAZA" "Service Role Key[concealed]=REEMPLAZA"
need_item "Stripe - Prod" "Secret Key[concealed]=REEMPLAZA"
need_item "Resend - Prod" "API Key[concealed]=REEMPLAZA"
need_item "DataForSEO - Prod" "Login[text]=REEMPLAZA" "Password[concealed]=REEMPLAZA"
need_item "BrightLocal - Prod" "API Key[concealed]=REEMPLAZA"

echo "Edita valores con: op item edit '<Título>' --vault '$VAULT' 'Campo=valor'"
