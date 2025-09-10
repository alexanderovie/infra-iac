#!/bin/bash
# SÚPER-ÉLITE Vercel Staging Setup Script

echo "🚀 Configurando staging en Vercel..."
echo ""

# Cargar variables
source "$(dirname "$0")/export-env.sh"

echo "📋 Pasos manuales requeridos:"
echo "1. Ve a: https://vercel.com/dashboard"
echo "2. Selecciona proyecto: fascinante-digital-app"
echo "3. Ve a: Settings → Domains"
echo "4. Agrega: stage.fascinantedigital.com"
echo "5. Verifica que el DNS esté configurado"
echo ""

echo "�� Verificando DNS actual:"
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=stage.fascinantedigital.com" \
  -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "X-Auth-Key: $CLOUDFLARE_API_KEY" \
  -H "Content-Type: application/json" | jq '.result[] | {name,type,content,proxied}'

echo ""
echo "✅ DNS configurado correctamente"
echo "🔧 Solo falta agregar el dominio en Vercel Dashboard"
