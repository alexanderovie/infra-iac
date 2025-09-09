# Pull Request - Fascinante Digital Infrastructure

## 📋 Descripción

<!-- Describe brevemente los cambios realizados en este PR -->

## 🎯 Tipo de Cambio

- [ ] 🐛 Bug fix (cambio que corrige un problema)
- [ ] ✨ Nueva funcionalidad (cambio que agrega funcionalidad)
- [ ] 💥 Breaking change (cambio que rompe compatibilidad)
- [ ] 📚 Documentación (cambio solo en documentación)
- [ ] 🔧 Refactorización (cambio que no corrige bugs ni agrega funcionalidad)
- [ ] ⚡ Performance (cambio que mejora el rendimiento)
- [ ] 🧪 Tests (agregar o modificar tests)
- [ ] 🔨 Build (cambios en el sistema de build o CI/CD)

## 🏗️ Cambios Realizados

<!-- Lista detallada de los cambios realizados -->

### Módulos Afectados
- [ ] `bootstrap/`
- [ ] `providers/cloudflare/`
- [ ] `providers/aws-ses/`
- [ ] `providers/aws-core/`
- [ ] `providers/github/`
- [ ] `providers/vercel/`
- [ ] `envs/dev/`
- [ ] `envs/stage/`
- [ ] `envs/prod/`
- [ ] `.github/workflows/`
- [ ] Documentación

### Archivos Modificados
<!-- Lista de archivos modificados -->

## 🧪 Testing

### Validaciones Ejecutadas
- [ ] `terraform fmt` ejecutado
- [ ] `terraform validate` ejecutado
- [ ] `tflint` ejecutado
- [ ] `tfsec` ejecutado
- [ ] `terraform plan` ejecutado para todos los entornos
- [ ] Pruebas manuales realizadas

### Entornos Probados
- [ ] Development
- [ ] Staging
- [ ] Production

### Resultados de Tests
<!-- Incluir capturas de pantalla o logs de tests si es relevante -->

## 🔒 Seguridad

### Secretos
- [ ] No hay secretos hardcodeados en el código
- [ ] Variables sensibles están marcadas como `sensitive = true`
- [ ] Archivos de secretos están encriptados con SOPS

### Permisos
- [ ] Principio de menor privilegio aplicado
- [ ] Roles IAM con permisos mínimos necesarios
- [ ] Recursos críticos tienen `prevent_destroy = true`

## 📊 Impacto

### Recursos Afectados
<!-- Lista de recursos de AWS/Cloudflare que serán creados/modificados/eliminados -->

### Costos
<!-- Estimación de impacto en costos (si aplica) -->

### Downtime
- [ ] Sin downtime
- [ ] Downtime mínimo esperado
- [ ] Downtime significativo (especificar)

## 📚 Documentación

### Actualizaciones Requeridas
- [ ] README.md actualizado
- [ ] Documentación de módulos actualizada
- [ ] Comentarios en código actualizados
- [ ] Ejemplos de uso actualizados

### Archivos de Documentación Modificados
<!-- Lista de archivos de documentación modificados -->

## 🚀 Deployment

### Plan de Despliegue
1. [ ] Aplicar en Development
2. [ ] Validar en Development
3. [ ] Aplicar en Staging
4. [ ] Validar en Staging
5. [ ] Aplicar en Production
6. [ ] Validar en Production

### Rollback Plan
<!-- Plan de rollback en caso de problemas -->

## 🔗 Referencias

### Issues Relacionados
<!-- Lista de issues relacionados (ej: Closes #123) -->

### Documentación Externa
<!-- Enlaces a documentación externa relevante -->

## 📸 Screenshots

<!-- Capturas de pantalla de cambios visuales o de configuración -->

## ✅ Checklist

### Antes de Enviar
- [ ] Código sigue las convenciones del proyecto
- [ ] Tests pasan localmente
- [ ] Documentación actualizada
- [ ] No hay secretos hardcodeados
- [ ] Commits son atómicos y descriptivos
- [ ] Rama actualizada con main

### Durante la Revisión
- [ ] Comentarios de revisores respondidos
- [ ] Cambios solicitados aplicados
- [ ] Tests ejecutados después de cambios
- [ ] Commits squashed si es necesario

### Antes de Merge
- [ ] Al menos 2 aprobaciones
- [ ] Todos los checks de CI pasan
- [ ] No hay conflictos de merge
- [ ] Documentación completa y actualizada

## 📝 Notas Adicionales

<!-- Cualquier información adicional relevante -->

---

**Revisor:** @fascinante-digital/infra-team
**Aprobación requerida:** @fascinante-digital/infra-leads
