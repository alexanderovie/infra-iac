#!/bin/bash
# Sanity check script for Fascinante Digital Infrastructure
# This script validates the infrastructure configuration

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TERRAFORM_VERSION="1.10"
TFLINT_VERSION="0.50.3"
TFSEC_VERSION="1.28.1"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 is not installed"
        return 1
    fi
    log_success "$1 is installed"
}

check_terraform_version() {
    local version
    version=$(terraform version -json | jq -r '.terraform_version')
    if [[ "$version" < "$TERRAFORM_VERSION" ]]; then
        log_error "Terraform version $version is below required $TERRAFORM_VERSION"
        return 1
    fi
    log_success "Terraform version $version is compatible"
}

check_file_exists() {
    if [[ ! -f "$1" ]]; then
        log_error "File $1 does not exist"
        return 1
    fi
    log_success "File $1 exists"
}

check_directory_structure() {
    log_info "Checking directory structure..."
    
    local dirs=(
        "bootstrap"
        "providers/cloudflare"
        "providers/aws-ses"
        "providers/aws-core"
        "providers/github"
        "providers/vercel"
        "envs/dev"
        "envs/stage"
        "envs/prod"
        ".github/workflows"
        "tools"
        "secrets"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_error "Directory $dir does not exist"
            return 1
        fi
        log_success "Directory $dir exists"
    done
}

check_terraform_files() {
    log_info "Checking Terraform files..."
    
    local files=(
        "bootstrap/main.tf"
        "bootstrap/variables.tf"
        "bootstrap/outputs.tf"
        "providers/cloudflare/main.tf"
        "providers/cloudflare/variables.tf"
        "providers/cloudflare/outputs.tf"
        "providers/aws-ses/main.tf"
        "providers/aws-ses/variables.tf"
        "providers/aws-ses/outputs.tf"
        "providers/aws-core/main.tf"
        "providers/aws-core/variables.tf"
        "providers/aws-core/outputs.tf"
        "envs/dev/main.tf"
        "envs/dev/providers.tf"
        "envs/dev/backend.hcl"
        "envs/dev/variables.tf"
        "envs/stage/main.tf"
        "envs/stage/providers.tf"
        "envs/stage/backend.hcl"
        "envs/stage/variables.tf"
        "envs/prod/main.tf"
        "envs/prod/providers.tf"
        "envs/prod/backend.hcl"
        "envs/prod/variables.tf"
    )
    
    for file in "${files[@]}"; do
        check_file_exists "$file"
    done
}

check_configuration_files() {
    log_info "Checking configuration files..."
    
    local files=(
        ".gitignore"
        ".editorconfig"
        "CODEOWNERS"
        "Makefile"
        ".pre-commit-config.yaml"
        ".sops.yaml"
        "tools/.tflint.hcl"
        "tools/tfsec-excludes.yml"
        "tools/infracost.yml"
        ".github/dependabot.yml"
        ".github/pull_request_template.md"
        ".github/ISSUE_TEMPLATE/bug_report.md"
        ".github/ISSUE_TEMPLATE/feature_request.md"
        ".github/ISSUE_TEMPLATE/security_issue.md"
    )
    
    for file in "${files[@]}"; do
        check_file_exists "$file"
    done
}

check_terraform_format() {
    log_info "Checking Terraform format..."
    
    if ! terraform fmt -check -recursive; then
        log_error "Terraform files are not properly formatted"
        log_info "Run 'terraform fmt -recursive' to fix formatting"
        return 1
    fi
    log_success "Terraform files are properly formatted"
}

check_terraform_validate() {
    log_info "Validating Terraform configurations..."
    
    local dirs=("bootstrap" "envs/dev" "envs/stage" "envs/prod")
    
    for dir in "${dirs[@]}"; do
        log_info "Validating $dir..."
        if ! (cd "$dir" && terraform init -backend=false && terraform validate); then
            log_error "Terraform validation failed for $dir"
            return 1
        fi
        log_success "Terraform validation passed for $dir"
    done
}

check_secrets() {
    log_info "Checking secrets configuration..."
    
    if [[ -f "secrets/dev.tfvars" ]]; then
        if file "secrets/dev.tfvars" | grep -q "encrypted"; then
            log_success "Development secrets are encrypted"
        else
            log_warning "Development secrets file exists but may not be encrypted"
        fi
    else
        log_warning "Development secrets file does not exist"
    fi
    
    if [[ -f "secrets/stage.tfvars" ]]; then
        if file "secrets/stage.tfvars" | grep -q "encrypted"; then
            log_success "Staging secrets are encrypted"
        else
            log_warning "Staging secrets file exists but may not be encrypted"
        fi
    else
        log_warning "Staging secrets file does not exist"
    fi
    
    if [[ -f "secrets/prod.tfvars" ]]; then
        if file "secrets/prod.tfvars" | grep -q "encrypted"; then
            log_success "Production secrets are encrypted"
        else
            log_warning "Production secrets file exists but may not be encrypted"
        fi
    else
        log_warning "Production secrets file does not exist"
    fi
}

check_naming_convention() {
    log_info "Checking naming convention..."
    
    # Check for fd- prefix in resource names
    local files=("bootstrap/main.tf" "providers/aws-ses/main.tf" "providers/aws-core/main.tf")
    
    for file in "${files[@]}"; do
        if grep -q "fd-" "$file"; then
            log_success "Naming convention (fd-) found in $file"
        else
            log_warning "Naming convention (fd-) not found in $file"
        fi
    done
}

check_prevent_destroy() {
    log_info "Checking prevent_destroy on critical resources..."
    
    local files=("bootstrap/main.tf" "providers/aws-ses/main.tf")
    
    for file in "${files[@]}"; do
        if grep -q "prevent_destroy = true" "$file"; then
            log_success "prevent_destroy found in $file"
        else
            log_warning "prevent_destroy not found in $file"
        fi
    done
}

check_documentation() {
    log_info "Checking documentation..."
    
    local files=(
        "README.md"
        "MIGRATIONS.md"
        "SECURITY.md"
        "CONTRIBUTING.md"
        "bootstrap/README.md"
        "providers/cloudflare/README.md"
        "providers/aws-ses/README.md"
        "providers/aws-core/README.md"
        "providers/github/README.md"
        "providers/vercel/README.md"
        "secrets/README.md"
    )
    
    for file in "${files[@]}"; do
        check_file_exists "$file"
    done
}

main() {
    log_info "Starting sanity check for Fascinante Digital Infrastructure..."
    echo
    
    # Check required commands
    log_info "Checking required commands..."
    check_command "terraform"
    check_command "tflint"
    check_command "tfsec"
    check_command "sops"
    check_command "age"
    check_command "jq"
    check_command "make"
    echo
    
    # Check Terraform version
    log_info "Checking Terraform version..."
    check_terraform_version
    echo
    
    # Check directory structure
    check_directory_structure
    echo
    
    # Check Terraform files
    check_terraform_files
    echo
    
    # Check configuration files
    check_configuration_files
    echo
    
    # Check Terraform format
    check_terraform_format
    echo
    
    # Check Terraform validation
    check_terraform_validate
    echo
    
    # Check secrets
    check_secrets
    echo
    
    # Check naming convention
    check_naming_convention
    echo
    
    # Check prevent_destroy
    check_prevent_destroy
    echo
    
    # Check documentation
    check_documentation
    echo
    
    log_success "Sanity check completed successfully!"
    log_info "Infrastructure is ready for deployment."
}

# Run main function
main "$@"
