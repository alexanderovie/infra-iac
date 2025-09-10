#!/usr/bin/env bash
set -euo pipefail

# 🚀 SÚPER-ÉLITE Real-time Consistency Monitor
# Monitorea el estado del repositorio en tiempo real

echo "=== 🚀 SÚPER-ÉLITE REAL-TIME MONITOR ==="
echo "Presiona Ctrl+C para salir"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para mostrar estado
show_status() {
    clear
    echo -e "${BLUE}=== 🚀 SÚPER-ÉLITE STATUS $(date +'%H:%M:%S') ===${NC}"
    echo ""

    # 1. Estado del repositorio
    echo -e "${BLUE}📁 REPOSITORIO:${NC}"
    if git status --porcelain | grep -q .; then
        echo -e "${YELLOW}⚠️  Hay cambios sin commitear${NC}"
        git status --short | head -5
    else
        echo -e "${GREEN}✅ Repositorio limpio${NC}"
    fi
    echo ""

    # 2. PRs abiertos
    echo -e "${BLUE}🔀 PULL REQUESTS:${NC}"
    PRS=$(gh pr list --state open --json number,title,author,mergeable --jq '.[] | "\(.number) - \(.title) (by \(.author.login)) - \(.mergeable)"' 2>/dev/null || echo "Error obteniendo PRs")
    if [ -n "$PRS" ]; then
        echo "$PRS" | while read -r line; do
            if echo "$line" | grep -q "MERGEABLE"; then
                echo -e "${GREEN}✅ $line${NC}"
            elif echo "$line" | grep -q "CONFLICTING"; then
                echo -e "${RED}❌ $line${NC}"
            else
                echo -e "${YELLOW}⚠️  $line${NC}"
            fi
        done
    else
        echo -e "${GREEN}✅ No hay PRs abiertos${NC}"
    fi
    echo ""

    # 3. Workflows recientes
    echo -e "${BLUE}🔄 WORKFLOWS:${NC}"
    RECENT_RUNS=$(gh run list --limit 3 --json status,conclusion,workflowName,createdAt --jq '.[] | "\(.workflowName) - \(.status) - \(.conclusion // "N/A") - \(.createdAt)"' 2>/dev/null || echo "Error obteniendo workflows")
    if [ -n "$RECENT_RUNS" ]; then
        echo "$RECENT_RUNS" | while read -r line; do
            if echo "$line" | grep -q "completed.*success"; then
                echo -e "${GREEN}✅ $line${NC}"
            elif echo "$line" | grep -q "completed.*failure"; then
                echo -e "${RED}❌ $line${NC}"
            elif echo "$line" | grep -q "in_progress"; then
                echo -e "${YELLOW}🔄 $line${NC}"
            else
                echo -e "${BLUE}ℹ️  $line${NC}"
            fi
        done
    else
        echo -e "${GREEN}✅ No hay workflows recientes${NC}"
    fi
    echo ""

    # 4. Estado de 1Password
    echo -e "${BLUE}🔐 1PASSWORD:${NC}"
    if op whoami &>/dev/null; then
        echo -e "${GREEN}✅ 1Password CLI autenticado${NC}"

        # Verificar items críticos
        CRITICAL_ITEMS=("AWS - Prod" "Cloudflare - Prod" "GitHub - PAT")
        for item in "${CRITICAL_ITEMS[@]}"; do
            if op item get "$item" --vault "Fascinante Digital Infrastructure" &>/dev/null; then
                echo -e "${GREEN}  ✅ $item${NC}"
            else
                echo -e "${RED}  ❌ $item${NC}"
            fi
        done
    else
        echo -e "${RED}❌ 1Password CLI no autenticado${NC}"
    fi
    echo ""

    # 5. Estado de Terraform
    echo -e "${BLUE}🏗️  TERRAFORM:${NC}"
    if make tf-validate &>/dev/null; then
        echo -e "${GREEN}✅ Terraform válido${NC}"
    else
        echo -e "${RED}❌ Terraform tiene errores${NC}"
    fi
    echo ""

    # 6. Próximas acciones recomendadas
    echo -e "${BLUE}🎯 ACCIONES RECOMENDADAS:${NC}"

    # Verificar si hay PRs listos para mergear
    MERGEABLE_PRS=$(gh pr list --state open --author "app/dependabot" --json number,mergeable --jq '.[] | select(.mergeable == "MERGEABLE") | .number' 2>/dev/null || echo "")
    if [ -n "$MERGEABLE_PRS" ]; then
        echo -e "${YELLOW}🔄 Ejecutar: ./scripts/auto-merge-pr.sh [PR_NUMBER]${NC}"
    fi

    # Verificar si hay cambios sin commitear
    if git status --porcelain | grep -q .; then
        echo -e "${YELLOW}📝 Ejecutar: git add . && git commit -m 'message'${NC}"
    fi

    # Verificar si hay workflows fallidos
    FAILED_RUNS=$(gh run list --status failure --limit 1 --json number --jq '.[0].number' 2>/dev/null || echo "")
    if [ -n "$FAILED_RUNS" ] && [ "$FAILED_RUNS" != "null" ]; then
        echo -e "${RED}🔧 Revisar workflow fallido: Run #$FAILED_RUNS${NC}"
    fi

    echo ""
    echo -e "${BLUE}⏱️  Actualizando en 30 segundos... (Ctrl+C para salir)${NC}"
}

# Función para manejar Ctrl+C
cleanup() {
    echo ""
    echo -e "${GREEN}👋 Monitor detenido. ¡Hasta luego!${NC}"
    exit 0
}

trap cleanup INT

# Loop principal
while true; do
    show_status
    sleep 30
done
