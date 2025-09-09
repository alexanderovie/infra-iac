# Guía de Contribución - Fascinante Digital

Esta guía explica cómo contribuir al repositorio de infraestructura de Fascinante Digital.

## 🚀 Flujo de Trabajo

### 1. Fork del Repositorio

```bash
# 1. Fork en GitHub
# Ir a https://github.com/fascinante-digital/infra-iac
# Hacer clic en "Fork"

# 2. Clonar tu fork
git clone https://github.com/tu-usuario/infra-iac.git
cd infra-iac

# 3. Agregar upstream
git remote add upstream https://github.com/fascinante-digital/infra-iac.git
```

### 2. Crear Rama de Feature

```bash
# 1. Actualizar main
git checkout main
git pull upstream main

# 2. Crear rama de feature
git checkout -b feature/nueva-funcionalidad
# o
git checkout -b fix/corregir-bug
# o
git checkout -b docs/actualizar-documentacion
```

### 3. Hacer Cambios

```bash
# 1. Hacer cambios en el código
# Editar archivos necesarios

# 2. Verificar cambios
terraform fmt -check -recursive
tflint --config tools/.tflint.hcl
tfsec --config-file tools/tfsec-excludes.yml

# 3. Commit con mensaje descriptivo
git add .
git commit -m "feat: agregar módulo de Vercel para despliegues"
```

### 4. Push y Pull Request

```bash
# 1. Push de la rama
git push origin feature/nueva-funcionalidad

# 2. Crear Pull Request en GitHub
# Ir a tu fork en GitHub
# Hacer clic en "Compare & pull request"
```

## 📝 Convenciones de Commits

### Formato

```
tipo(scope): descripción

Cuerpo del commit (opcional)

Footer (opcional)
```

### Tipos

- **feat**: Nueva funcionalidad
- **fix**: Corrección de bug
- **docs**: Cambios en documentación
- **style**: Cambios de formato (espacios, etc.)
- **refactor**: Refactorización de código
- **test**: Agregar o modificar tests
- **chore**: Cambios en herramientas, configuración, etc.

### Ejemplos

```bash
# Nueva funcionalidad
git commit -m "feat(cloudflare): agregar soporte para registros MX"

# Corrección de bug
git commit -m "fix(aws-ses): corregir validación de dominio"

# Documentación
git commit -m "docs: actualizar guía de inicio rápido"

# Refactorización
git commit -m "refactor(providers): simplificar configuración de módulos"
```

## 🏗️ Estructura de Pull Requests

### Título

```
tipo(scope): descripción breve
```

### Descripción

```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva funcionalidad
- [ ] Breaking change
- [ ] Documentación

## Cambios Realizados
- Lista de cambios específicos
- Módulos afectados
- Archivos modificados

## Testing
- [ ] Terraform plan ejecutado
- [ ] TFLint pasado
- [ ] TFSec pasado
- [ ] Pruebas manuales realizadas

## Screenshots (si aplica)
Capturas de pantalla de los cambios.

## Checklist
- [ ] Código sigue las convenciones del proyecto
- [ ] Documentación actualizada
- [ ] No hay secretos hardcodeados
- [ ] Tests pasan
- [ ] Cambios son backwards compatible
```

## 🧪 Testing

### Antes de Enviar PR

```bash
# 1. Formato de código
terraform fmt -check -recursive

# 2. Linting
tflint --config tools/.tflint.hcl

# 3. Seguridad
tfsec --config-file tools/tfsec-excludes.yml

# 4. Validación
cd envs/dev/
terraform init -backend=false
terraform validate
terraform plan
```

### Testing Manual

```bash
# 1. Probar en entorno de desarrollo
cd envs/dev/
terraform init -backend-config=backend.hcl
terraform plan
terraform apply

# 2. Verificar recursos creados
aws s3 ls
aws dynamodb list-tables

# 3. Limpiar recursos de prueba
terraform destroy
```

## 📋 Checklist de PR

### Antes de Enviar

- [ ] **Código**: Sigue las convenciones del proyecto
- [ ] **Tests**: Todos los tests pasan
- [ ] **Documentación**: README actualizado si es necesario
- [ ] **Secretos**: No hay secretos hardcodeados
- [ ] **Commits**: Mensajes descriptivos y atómicos
- [ ] **Rama**: Actualizada con main

### Durante la Revisión

- [ ] **Comentarios**: Responder a todos los comentarios
- [ ] **Cambios**: Aplicar cambios solicitados
- [ ] **Tests**: Ejecutar tests después de cambios
- [ ] **Commits**: Squash commits si es necesario

### Antes de Merge

- [ ] **Aprobación**: Al menos 2 aprobaciones
- [ ] **CI/CD**: Todos los checks pasan
- [ ] **Conflicts**: No hay conflictos de merge
- [ ] **Documentación**: Actualizada y completa

## 🔧 Configuración del Entorno

### Prerrequisitos

```bash
# 1. Instalar Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# 2. Instalar TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# 3. Instalar TFSec
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# 4. Instalar AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Configuración Local

```bash
# 1. Configurar AWS
aws configure

# 2. Configurar Git
git config --global user.name "Tu Nombre"
git config --global user.email "tu-email@fascinantedigital.com"

# 3. Configurar pre-commit (opcional)
pip install pre-commit
pre-commit install
```

## 📚 Documentación

### Agregar Nuevos Módulos

1. **Crear estructura**:
   ```
   providers/nuevo-proveedor/
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   └── README.md
   ```

2. **Documentar en README**:
   - Descripción del módulo
   - Variables requeridas
   - Ejemplos de uso
   - Outputs disponibles

3. **Actualizar documentación principal**:
   - Agregar a README.md principal
   - Actualizar ejemplos de uso

### Actualizar Documentación

- **README.md**: Cambios en funcionalidad principal
- **MIGRATIONS.md**: Cambios en migración
- **SECURITY.md**: Cambios en seguridad
- **CONTRIBUTING.md**: Cambios en proceso de contribución

## 🐛 Reportar Bugs

### Template de Bug Report

```markdown
## Descripción
Descripción clara del bug.

## Pasos para Reproducir
1. Ir a '...'
2. Hacer clic en '...'
3. Ver error

## Comportamiento Esperado
Qué debería pasar.

## Comportamiento Actual
Qué está pasando.

## Screenshots
Capturas de pantalla si es aplicable.

## Entorno
- OS: [e.g. Ubuntu 20.04]
- Terraform: [e.g. 1.6.0]
- Provider: [e.g. AWS 5.0]

## Información Adicional
Cualquier información adicional relevante.
```

## 💡 Sugerir Mejoras

### Template de Feature Request

```markdown
## Descripción
Descripción clara de la mejora sugerida.

## Problema que Resuelve
Qué problema resuelve esta mejora.

## Solución Propuesta
Descripción de la solución propuesta.

## Alternativas Consideradas
Otras soluciones consideradas.

## Información Adicional
Cualquier información adicional relevante.
```

## 🏷️ Etiquetas de Issues

- **bug**: Algo no funciona
- **enhancement**: Nueva funcionalidad
- **documentation**: Mejoras en documentación
- **question**: Pregunta o soporte
- **wontfix**: No se va a arreglar
- **duplicate**: Issue duplicado
- **help wanted**: Se necesita ayuda

## 📞 Soporte

### Canales de Comunicación

- **GitHub Issues**: Para bugs y feature requests
- **GitHub Discussions**: Para preguntas generales
- **Slack**: #infra-team para discusiones rápidas
- **Email**: [info@fascinantedigital.com](mailto:info@fascinantedigital.com) para temas urgentes

### Horarios de Soporte

- **Lunes a Viernes**: 9:00 AM - 6:00 PM (CST)
- **Respuesta a Issues**: 24-48 horas
- **Respuesta a PRs**: 1-3 días hábiles

## 🎉 Reconocimientos

### Contribuidores

- **Core Team**: @fascinante-digital/infra-team
- **Maintainers**: @fascinante-digital/infra-leads
- **Contributors**: Ver [CONTRIBUTORS.md](CONTRIBUTORS.md)

### Agradecimientos

Gracias a todos los contribuidores que hacen posible este proyecto.

---

**¡Gracias por contribuir a Fascinante Digital!** 🚀
