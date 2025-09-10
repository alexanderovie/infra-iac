#!/bin/bash
# SÚPER-ÉLITE Environment Verification Script

echo "🔍 Verificando variables de entorno SÚPER-ÉLITE..."
echo ""

# Verificar variables críticas
variables=(
    "CLOUDFLARE_API_KEY"
    "CLOUDFLARE_EMAIL"
    "ZONE_ID"
    "AWS_ACCESS_KEY_ID"
    "GITHUB_TOKEN"
    "VERCEL_TOKEN"
)

all_good=true

for var in "${variables[@]}"; do
    if [ -n "${!var}" ]; then
        echo "✅ $var: ${!var:0:10}..."
    else
        echo "❌ $var: NO DEFINIDA"
        all_good=false
    fi
done

echo ""
if [ "$all_good" = true ]; then
    echo "🎉 ¡TODAS LAS VARIABLES ESTÁN CONFIGURADAS SÚPER-ÉLITE!"
    echo "🚀 Puedes usar los comandos desde cualquier directorio"
else
    echo "⚠️  Algunas variables faltan. Ejecuta: source ~/.fascinante-env"
fi

echo ""
echo "🔧 Comandos disponibles:"
echo "   - fascinante                    # Cargar variables"
echo "   - source ~/.fascinante-env      # Cargar variables"
echo "   - ./scripts/cloudflare-dns.sh   # Consultas DNS"
