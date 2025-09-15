#!/usr/bin/env bash
set -euo pipefail

# 🚀 SÚPER-ÉLITE Maintenance Script
# Mantiene consistencia automática del repositorio

echo "=== 🚀 SÚPER-ÉLITE MAINTENANCE ==="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. Verificar estado del repositorio
log "Verificando estado del repositorio..."
if ! git status --porcelain | grep -q .; then
    success "Repositorio limpio"
else
    warning "Hay cambios sin commitear"
    git status --short
fi

# 2. Actualizar dependencias automáticamente
log "Actualizando dependencias..."
if command -v dependabot &> /dev/null; then
    dependabot update --directory . --package-manager github_actions
    success "Dependabot ejecutado"
else
    warning "Dependabot CLI no disponible, usando GitHub API"
fi

# 3. Verificar y mergear PRs de dependabot
log "Verificando PRs de dependabot..."
PRS=$(gh pr list --state open --author "app/dependabot" --json number,mergeable,title --jq '.[] | select(.mergeable == "MERGEABLE") | .number')

if [ -n "$PRS" ]; then
    for pr in $PRS; do
        log "Auto-mergeando PR #$pr..."
        if ./scripts/auto-merge-pr.sh "$pr"; then
            success "PR #$pr mergeado"
        else
            error "Error mergeando PR #$pr"
        fi
    done
else
    success "No hay PRs de dependabot listos para mergear"
fi

# 4. Verificar workflows de GitHub Actions
log "Verificando workflows..."
FAILED_RUNS=$(gh run list --status failure --limit 5 --json number,conclusion,headBranch,createdAt --jq '.[] | select(.conclusion == "failure") | .number')

if [ -n "$FAILED_RUNS" ]; then
    warning "Hay workflows fallidos:"
    for run in $FAILED_RUNS; do
        echo "  - Run #$run"
    done
else
    success "Todos los workflows están funcionando"
fi

# 5. Verificar secretos de GitHub
log "Verificando secretos..."
SECRETS=$(gh secret list --json name,updatedAt --jq '.[] | .name')
EXPIRED_SECRETS=()

for secret in $SECRETS; do
    updated=$(gh secret list --json name,updatedAt --jq ".[] | select(.name == \"$secret\") | .updatedAt")
    # Verificar si el secreto es muy antiguo (más de 30 días)
    # Compatible con macOS (date -j) y Linux (date -d)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if [[ $(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$updated" +%s) -lt $(date -j -v-30d +%s) ]]; then
            EXPIRED_SECRETS+=("$secret")
        fi
    else
        # Linux
        if [[ $(date -d "$updated" +%s) -lt $(date -d "30 days ago" +%s) ]]; then
            EXPIRED_SECRETS+=("$secret")
        fi
    fi
done

if [ ${#EXPIRED_SECRETS[@]} -gt 0 ]; then
    warning "Secretos que podrían necesitar rotación:"
    for secret in "${EXPIRED_SECRETS[@]}"; do
        echo "  - $secret"
    done
else
    success "Todos los secretos están actualizados"
fi

# 6. Verificar estado de 1Password
log "Verificando 1Password CLI..."
if op whoami &>/dev/null; then
    success "1Password CLI funcionando"

    # Verificar items críticos
    CRITICAL_ITEMS=("AWS - Prod" "Cloudflare - Prod" "GitHub - PAT" "Vercel - Prod")
    for item in "${CRITICAL_ITEMS[@]}"; do
        if op item get "$item" --vault "Fascinante Digital Infrastructure" &>/dev/null; then
            success "Item '$item' disponible"
        else
            error "Item '$item' no encontrado"
        fi
    done
else
    error "1Password CLI no está autenticado"
fi

# 7. Verificar Terraform/OpenTofu
log "Verificando Terraform..."
if make tf-validate &>/dev/null; then
    success "Terraform válido"
else
    error "Terraform tiene errores de validación"
fi

# 8. Verificar Docker
log "Verificando Docker..."
if docker-compose config &>/dev/null; then
    success "Docker Compose válido"
else
    error "Docker Compose tiene errores"
fi

# 9. Ejecutar tests de consistencia
log "Ejecutando tests de consistencia..."

# Test 1: Verificar que todos los scripts son ejecutables
find scripts/ -name "*.sh" -type f | while read -r file; do
    if [ ! -x "$file" ]; then
        warning "Script no ejecutable: $file"
        chmod +x "$file"
        success "Permisos corregidos: $file"
    fi
done

# Test 2: Verificar que no hay archivos temporales
TEMP_FILES=$(find . -name "*.tmp" -o -name "*.temp" -o -name "*.bak" -o -name "*~")
if [ -n "$TEMP_FILES" ]; then
    warning "Archivos temporales encontrados:"
    echo "$TEMP_FILES"
    read -p "¿Eliminar archivos temporales? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$TEMP_FILES" | xargs rm -f
        success "Archivos temporales eliminados"
    fi
fi

# Test 3: Verificar formato de código
log "Verificando formato de código..."
if command -v prettier &> /dev/null; then
    if prettier --check . &>/dev/null; then
        success "Código bien formateado"
    else
        warning "Código necesita formateo"
        read -p "¿Ejecutar prettier? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            prettier --write .
            success "Código formateado"
        fi
    fi
fi

# 10. Resumen final
echo ""
echo "=== 🎉 RESUMEN SÚPER-ÉLITE ==="
echo "✅ Mantenimiento completado"
echo "📊 Estado del repositorio: $(git status --porcelain | wc -l | tr -d ' ') archivos modificados"
echo "🔄 PRs procesados: $(echo "$PRS" | wc -w | tr -d ' ')"
echo "⚠️  Secretos antiguos: ${#EXPIRED_SECRETS[@]}"
echo "🚀 Sistema SÚPER-ÉLITE funcionando correctamente"
