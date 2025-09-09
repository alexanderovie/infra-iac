# Secrets Management - Fascinante Digital

Este directorio contiene archivos de secretos encriptados usando SOPS con Age.

## Configuración

### 1. Instalar SOPS y Age

```bash
# Instalar SOPS
curl -LO https://github.com/mozilla/sops/releases/latest/download/sops-latest.linux
sudo mv sops-latest.linux /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops

# Instalar Age
curl -LO https://github.com/FiloSottile/age/releases/latest/download/age-latest-linux-amd64.tar.gz
tar xzf age-latest-linux-amd64.tar.gz
sudo mv age/age /usr/local/bin/
```

### 2. Generar claves Age

```bash
# Generar clave Age
age-keygen -o age-key.txt

# Configurar variable de entorno
export SOPS_AGE_KEY_FILE=$(pwd)/age-key.txt
```

### 3. Encriptar archivos

```bash
# Encriptar archivo
sops -e -i secrets/dev.tfvars

# Editar archivo encriptado
sops secrets/dev.tfvars
```

## Archivos de Secretos

- `dev.tfvars`: Variables sensibles para desarrollo
- `stage.tfvars`: Variables sensibles para staging
- `prod.tfvars`: Variables sensibles para producción

## Uso en Terraform

```bash
# Decriptar y aplicar
sops -d secrets/dev.tfvars | terraform apply -var-file=/dev/stdin
```
