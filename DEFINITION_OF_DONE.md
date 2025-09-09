# Definition of Done - Fascinante Digital Infrastructure

Esta definición establece los criterios que deben cumplirse para considerar que un cambio en la infraestructura está **completamente terminado** y listo para producción.

## 🎯 Criterios de Validación

### 1. Código y Configuración

#### ✅ Terraform
- [ ] **Formato**: Todos los archivos `.tf` están formateados con `terraform fmt`
- [ ] **Validación**: `terraform validate` pasa sin errores en todos los entornos
- [ ] **Linting**: `tflint` pasa sin errores en todas las configuraciones
- [ ] **Seguridad**: `tfsec` pasa sin errores críticos
- [ ] **Versiones**: Terraform >= 1.10 y providers actualizados
- [ ] **Lock files**: `.terraform.lock.hcl` actualizado y commiteado

#### ✅ Naming Convention
- [ ] **Recursos**: Siguen el patrón `fd-{env}-{area}-{name}`
- [ ] **Variables**: Nombres descriptivos y consistentes
- [ ] **Módulos**: Estructura modular y reutilizable
- [ ] **Tags**: Todos los recursos tienen tags estándar

#### ✅ Seguridad
- [ ] **Secretos**: No hay secretos hardcodeados en el código
- [ ] **SOPS**: Archivos sensibles encriptados con SOPS/Age
- [ ] **Permisos**: Principio de menor privilegio aplicado
- [ ] **Prevent Destroy**: Recursos críticos protegidos
- [ ] **Variables**: Variables sensibles marcadas como `sensitive = true`

### 2. Testing y Validación

#### ✅ Testing Local
- [ ] **Plan**: `terraform plan` ejecutado en todos los entornos
- [ ] **Sanity Check**: Script de sanity check pasa sin errores
- [ ] **Pre-commit**: Hooks de pre-commit configurados y funcionando
- [ ] **Manual**: Pruebas manuales realizadas en entorno de desarrollo

#### ✅ CI/CD
- [ ] **Workflows**: GitHub Actions configurados y funcionando
- [ ] **Dependabot**: Configurado para actualizaciones automáticas
- [ ] **Drift Detection**: Workflow de detección de drift configurado
- [ ] **Approvals**: Proceso de aprobación configurado para producción

### 3. Documentación

#### ✅ Documentación Técnica
- [ ] **README**: Documentación principal actualizada
- [ ] **Módulos**: README individual para cada módulo
- [ ] **Ejemplos**: Ejemplos de uso actualizados
- [ ] **Variables**: Documentación de inputs/outputs
- [ ] **Migraciones**: Guía de migración actualizada si aplica

#### ✅ Documentación de Proceso
- [ ] **Contributing**: Guía de contribución actualizada
- [ ] **Security**: Políticas de seguridad actualizadas
- [ ] **Templates**: Templates de PR e Issues actualizados
- [ ] **CODEOWNERS**: Responsabilidades actualizadas

### 4. Despliegue

#### ✅ Entornos
- [ ] **Development**: Desplegado y validado
- [ ] **Staging**: Desplegado y validado
- [ ] **Production**: Desplegado y validado (si aplica)
- [ ] **Rollback**: Plan de rollback documentado

#### ✅ Monitoreo
- [ ] **Logs**: Logs de despliegue revisados
- [ ] **Métricas**: Métricas de infraestructura verificadas
- [ ] **Alertas**: Alertas configuradas y funcionando
- [ ] **Drift**: Sin drift detectado en producción

### 5. Comunicación

#### ✅ Stakeholders
- [ ] **Equipo**: Equipo de infraestructura notificado
- [ ] **Aprobaciones**: Aprobaciones requeridas obtenidas
- [ ] **Comunicación**: Cambios comunicados a stakeholders
- [ ] **Documentación**: Cambios documentados en changelog

#### ✅ Post-Despliegue
- [ ] **Verificación**: Funcionalidad verificada en producción
- [ ] **Monitoreo**: Monitoreo activo por 24-48 horas
- [ ] **Feedback**: Feedback recopilado de usuarios
- [ ] **Lecciones**: Lecciones aprendidas documentadas

## 🔍 Checklist de Validación

### Antes de Enviar PR
```bash
# Ejecutar sanity check
./scripts/sanity-check.sh

# Validar formato
terraform fmt -check -recursive

# Validar configuración
make validate

# Ejecutar linting
make lint

# Ejecutar seguridad
make security
```

### Antes de Merge
```bash
# Plan en todos los entornos
make all-plan

# Verificar aprobaciones
# - Al menos 2 aprobaciones
# - Aprobación de infra-leads para producción

# Verificar CI/CD
# - Todos los checks pasan
# - No hay conflictos de merge
```

### Después de Merge
```bash
# Aplicar en desarrollo
make apply-dev

# Verificar funcionamiento
make status

# Aplicar en staging
make apply-stage

# Verificar funcionamiento
make status

# Aplicar en producción (si aplica)
make apply-prod

# Verificar funcionamiento
make status
```

## 🚨 Criterios de Bloqueo

### ❌ No Merge si:
- [ ] Tests fallan
- [ ] Linting falla
- [ ] Seguridad falla
- [ ] Documentación incompleta
- [ ] Secretos expuestos
- [ ] Sin aprobaciones requeridas
- [ ] Conflictos de merge
- [ ] Drift detectado

### ❌ No Producción si:
- [ ] No validado en staging
- [ ] Sin plan de rollback
- [ ] Sin monitoreo configurado
- [ ] Sin aprobación de infra-leads
- [ ] Cambios breaking sin migración

## 📊 Métricas de Calidad

### Cobertura de Testing
- [ ] **Terraform**: 100% de archivos validados
- [ ] **Linting**: 0 errores críticos
- [ ] **Seguridad**: 0 vulnerabilidades críticas
- [ ] **Documentación**: 100% de módulos documentados

### Tiempo de Despliegue
- [ ] **Development**: < 5 minutos
- [ ] **Staging**: < 10 minutos
- [ ] **Production**: < 15 minutos

### Disponibilidad
- [ ] **Uptime**: > 99.9%
- [ ] **RTO**: < 1 hora
- [ ] **RPO**: < 15 minutos

## 🎯 Criterios de Éxito

### Funcionalidad
- [ ] **Objetivos**: Todos los objetivos del cambio cumplidos
- [ ] **Performance**: Sin degradación de rendimiento
- [ ] **Seguridad**: Mejora o mantenimiento del nivel de seguridad
- [ ] **Usabilidad**: Mejora en la experiencia del usuario

### Operacional
- [ ] **Monitoreo**: Visibilidad completa de la infraestructura
- [ ] **Alertas**: Alertas proactivas configuradas
- [ ] **Documentación**: Documentación completa y actualizada
- [ ] **Procesos**: Procesos de operación actualizados

### Técnico
- [ ] **Código**: Código limpio y mantenible
- [ ] **Arquitectura**: Arquitectura escalable y resiliente
- [ ] **Seguridad**: Seguridad por diseño implementada
- [ ] **Automatización**: Automatización completa del ciclo de vida

## 📝 Template de Validación

```markdown
## ✅ Definition of Done Checklist

### Código y Configuración
- [ ] Terraform formateado y validado
- [ ] Linting y seguridad pasan
- [ ] Naming convention aplicada
- [ ] Secretos manejados correctamente

### Testing y Validación
- [ ] Tests locales pasan
- [ ] CI/CD configurado
- [ ] Sanity check pasa
- [ ] Pruebas manuales realizadas

### Documentación
- [ ] README actualizado
- [ ] Módulos documentados
- [ ] Ejemplos actualizados
- [ ] Procesos documentados

### Despliegue
- [ ] Entornos validados
- [ ] Monitoreo configurado
- [ ] Rollback plan listo
- [ ] Stakeholders notificados

### Comunicación
- [ ] Equipo notificado
- [ ] Aprobaciones obtenidas
- [ ] Cambios comunicados
- [ ] Post-despliegue verificado
```

---

**Responsable**: @fascinante-digital/infra-leads
**Revisión**: Mensual
**Última actualización**: Septiembre 2025
