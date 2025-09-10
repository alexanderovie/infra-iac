#!/usr/bin/env bash
set -euo pipefail

# 🚀 Script para configurar cron jobs SÚPER-ÉLITE
# Ejecuta mantenimiento automático diario

echo "=== 🚀 CONFIGURANDO CRON SÚPER-ÉLITE ==="

# Obtener directorio actual
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAINTENANCE_SCRIPT="$REPO_DIR/scripts/maintain-consistency.sh"

# Crear entrada de cron
CRON_ENTRY="0 9 * * * cd $REPO_DIR && $MAINTENANCE_SCRIPT >> $REPO_DIR/logs/maintenance.log 2>&1"

# Crear directorio de logs
mkdir -p "$REPO_DIR/logs"

# Agregar al crontab
(crontab -l 2>/dev/null | grep -v "maintain-consistency"; echo "$CRON_ENTRY") | crontab -

echo "✅ Cron job configurado:"
echo "   - Ejecución: Diario a las 9:00 AM"
echo "   - Log: $REPO_DIR/logs/maintenance.log"
echo "   - Script: $MAINTENANCE_SCRIPT"

# Crear script de monitoreo
cat > "$REPO_DIR/scripts/monitor-maintenance.sh" << 'EOF'
#!/usr/bin/env bash
# Script para monitorear el mantenimiento automático

LOG_FILE="logs/maintenance.log"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== 📊 MONITOR SÚPER-ÉLITE ==="
echo "Log file: $REPO_DIR/$LOG_FILE"
echo ""

if [ -f "$REPO_DIR/$LOG_FILE" ]; then
    echo "📈 Últimas 10 líneas del log:"
    tail -10 "$REPO_DIR/$LOG_FILE"
    echo ""

    echo "📊 Estadísticas:"
    echo "  - Ejecuciones exitosas: $(grep -c "RESUMEN SÚPER-ÉLITE" "$REPO_DIR/$LOG_FILE" || echo "0")"
    echo "  - Errores: $(grep -c "❌" "$REPO_DIR/$LOG_FILE" || echo "0")"
    echo "  - Warnings: $(grep -c "⚠️" "$REPO_DIR/$LOG_FILE" || echo "0")"
else
    echo "❌ Log file no encontrado"
fi
EOF

chmod +x "$REPO_DIR/scripts/monitor-maintenance.sh"

echo "✅ Script de monitoreo creado: scripts/monitor-maintenance.sh"
echo ""
echo "🎯 COMANDOS ÚTILES:"
echo "  - Ver logs: tail -f logs/maintenance.log"
echo "  - Monitorear: ./scripts/monitor-maintenance.sh"
echo "  - Ejecutar manual: ./scripts/maintain-consistency.sh"
echo "  - Ver cron: crontab -l"
