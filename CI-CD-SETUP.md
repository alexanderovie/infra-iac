# 🚀 CI/CD Setup SÚPER-ÉLITE - September 2025

## 📋 GitHub Secrets Required

Configure these secrets in GitHub → Settings → Secrets and variables → Actions:

### **Required Secrets:**

- `AWS_ACCESS_KEY_ID` - AWS access key for S3 backend
- `AWS_SECRET_ACCESS_KEY` - AWS secret key for S3 backend
- `CLOUDFLARE_EMAIL` - Cloudflare account email
- `CLOUDFLARE_API_KEY` - Cloudflare API key

### **Optional Secrets (for future Vercel integration):**

- `VERCEL_TOKEN` - Vercel API token
- `VERCEL_TEAM_ID` - Vercel team ID

## 🔧 Workflows Available (SÚPER-ÉLITE 2025)

### **1. plan-dev-opentofu.yml**

- **Trigger**: Pull requests (envs/dev changes)
- **Purpose**: Run `tofu plan` on PRs
- **Tools**: OpenTofu 1.10.6
- **Features**:
  - Caching optimizado
  - Artifact upload
  - Path-based triggers

### **2. validate-infrastructure.yml**

- **Trigger**: Push + Pull requests
- **Purpose**: Full validation pipeline
- **Tools**:
  - OpenTofu 1.10.6
  - TFLint 0.50+ (linting avanzado)
  - TFSec (security scan)
  - Checkov (security adicional)
  - Trivy (vulnerability scanning)
  - Format validation

### **3. drift-detection.yml**

- **Trigger**: Weekly (Lunes 2 AM UTC) + Manual
- **Purpose**: Detectar drift en infraestructura
- **Features**:
  - Reporte automático
  - Issue creation
  - Artifact storage

## 🧪 Testing CI/CD

1. **Create a test PR:**

   ```bash
   git checkout -b test-ci-cd
   git add .
   git commit -m "test: validate CI/CD pipeline"
   git push origin test-ci-cd
   ```

2. **Expected Results:**
   - ✅ `plan` job: "No changes"
   - ✅ `validate` job: All checks green
   - ✅ Security scan: No critical issues

## 🔒 Security Features

- **TFSec**: Security scanning for Terraform
- **TFLint**: Advanced linting rules
- **Detect Secrets**: Prevents credential leaks
- **Pre-commit**: Local validation before push

## 📊 Monitoring

- **GitHub Actions**: View results in Actions tab
- **Security**: TFSec reports in workflow logs
- **Performance**: OpenTofu faster than Terraform

---

**Status**: ✅ Ready for production CI/CD **Last Updated**: September 2025
**Version**: SÚPER-ÉLITE
