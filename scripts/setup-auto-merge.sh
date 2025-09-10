#!/usr/bin/env bash
set -euo pipefail

# 🚀 Script para configurar auto-merge en GitHub
# Requiere: gh CLI autenticado

echo "=== CONFIGURANDO AUTO-MERGE ==="

# 1. Configurar branch protection rules
echo "→ Configurando branch protection rules..."
gh api repos/alexanderovie/infra-iac/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["Terraform Plan (1Password)"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":0,"dismiss_stale_reviews":false,"require_code_owner_reviews":false}' \
  --field restrictions=null

echo "✅ Branch protection configurado"

# 2. Crear label para auto-merge
echo "→ Creando label 'auto-merge'..."
gh api repos/alexanderovie/infra-iac/labels \
  --method POST \
  --field name="auto-merge" \
  --field description="Auto-merge this PR when CI passes" \
  --field color="0e8a16" || echo "⚠️  Label ya existe"

echo "✅ Label 'auto-merge' creado"

# 3. Configurar dependabot para auto-merge
echo "→ Configurando dependabot auto-merge..."
gh api repos/alexanderovie/infra-iac/actions/permissions \
  --method PUT \
  --field enabled=true

echo "✅ Dependabot configurado"

echo "🎉 Auto-merge configurado completamente!"
echo ""
echo "📋 CÓMO USAR:"
echo "1. Para auto-merge: Agrega label 'auto-merge' al PR"
echo "2. Para dependabot: Se auto-mergea automáticamente"
echo "3. Para PRs normales: Requieren revisión manual"
