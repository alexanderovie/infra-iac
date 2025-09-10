#!/bin/bash
# SÚPER-ÉLITE GitHub Secrets Setup Script
# September 2025 - Modern best practices

set -e

echo "🚀 SÚPER-ÉLITE GitHub Secrets Setup"
echo "=================================="

# Cargar variables de entorno
source "$(dirname "$0")/export-env.sh"

# Verificar que GitHub CLI esté instalado
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI no está instalado. Instalando..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    else
        echo "Por favor instala GitHub CLI: https://cli.github.com/"
        exit 1
    fi
fi

# Verificar autenticación
if ! gh auth status &> /dev/null; then
    echo "❌ No estás autenticado con GitHub CLI"
    echo "Ejecuta: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI configurado correctamente"

# Configurar secrets
echo "🔐 Configurando secrets en GitHub..."

# AWS Secrets
echo "  - Configurando AWS_ACCESS_KEY_ID..."
gh secret set AWS_ACCESS_KEY_ID --body "$AWS_ACCESS_KEY_ID" --repo alexanderovie/infra-iac

echo "  - Configurando AWS_SECRET_ACCESS_KEY..."
gh secret set AWS_SECRET_ACCESS_KEY --body "$AWS_SECRET_ACCESS_KEY" --repo alexanderovie/infra-iac

# Cloudflare Secrets
echo "  - Configurando CLOUDFLARE_EMAIL..."
gh secret set CLOUDFLARE_EMAIL --body "$CLOUDFLARE_EMAIL" --repo alexanderovie/infra-iac

echo "  - Configurando CLOUDFLARE_API_KEY..."
gh secret set CLOUDFLARE_API_KEY --body "$CLOUDFLARE_API_KEY" --repo alexanderovie/infra-iac

# Vercel Secrets (opcional)
echo "  - Configurando VERCEL_TOKEN..."
gh secret set VERCEL_TOKEN --body "$VERCEL_TOKEN" --repo alexanderovie/infra-iac

echo "  - Configurando VERCEL_TEAM_ID..."
gh secret set VERCEL_TEAM_ID --body "$VERCEL_TEAM_ID" --repo alexanderovie/infra-iac

echo ""
echo "✅ SÚPER-ÉLITE Secrets configurados exitosamente!"
echo ""
echo "🔍 Verificando secrets configurados:"
gh secret list --repo alexanderovie/infra-iac

echo ""
echo "🚀 Próximos pasos:"
echo "1. Ve a: https://github.com/alexanderovie/infra-iac/actions"
echo "2. Re-ejecuta el workflow fallido"
echo "3. Verifica que funcione correctamente"
echo ""
echo "🎯 ¡Tu infraestructura SÚPER-ÉLITE está lista!"
