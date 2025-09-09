# Makefile for Fascinante Digital Infrastructure
# Provides commands for managing Terraform infrastructure

.PHONY: help install init plan apply destroy validate format lint security cost clean

# Default target
help: ## Show this help message
	@echo "Fascinante Digital Infrastructure Management"
	@echo "=========================================="
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Installation
install: ## Install required tools
	@echo "Installing required tools..."
	@command -v terraform >/dev/null 2>&1 || { echo "Terraform not found. Please install Terraform >= 1.10"; exit 1; }
	@command -v tflint >/dev/null 2>&1 || { echo "TFLint not found. Please install TFLint"; exit 1; }
	@command -v tfsec >/dev/null 2>&1 || { echo "TFSec not found. Please install TFSec"; exit 1; }
	@command -v sops >/dev/null 2>&1 || { echo "SOPS not found. Please install SOPS"; exit 1; }
	@command -v age >/dev/null 2>&1 || { echo "Age not found. Please install Age"; exit 1; }
	@echo "All tools are installed!"

# Bootstrap
bootstrap-init: ## Initialize bootstrap environment
	cd bootstrap && terraform init

bootstrap-plan: ## Plan bootstrap changes
	cd bootstrap && terraform plan

bootstrap-apply: ## Apply bootstrap changes
	cd bootstrap && terraform apply

bootstrap-destroy: ## Destroy bootstrap (DANGEROUS!)
	cd bootstrap && terraform destroy

# Environment management
init-dev: ## Initialize development environment
	cd envs/dev && terraform init -backend-config=backend.hcl

init-stage: ## Initialize staging environment
	cd envs/stage && terraform init -backend-config=backend.hcl

init-prod: ## Initialize production environment
	cd envs/prod && terraform init -backend-config=backend.hcl

# Planning
plan-dev: ## Plan development environment
	cd envs/dev && terraform plan

plan-stage: ## Plan staging environment
	cd envs/stage && terraform plan

plan-prod: ## Plan production environment
	cd envs/prod && terraform plan

# Applying
apply-dev: ## Apply development environment
	cd envs/dev && terraform apply

apply-stage: ## Apply staging environment
	cd envs/stage && terraform apply

apply-prod: ## Apply production environment (requires confirmation)
	@echo "WARNING: This will apply changes to PRODUCTION environment!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ]
	cd envs/prod && terraform apply

# Validation
validate: ## Validate all Terraform configurations
	@echo "Validating bootstrap..."
	cd bootstrap && terraform validate
	@echo "Validating dev environment..."
	cd envs/dev && terraform validate
	@echo "Validating stage environment..."
	cd envs/stage && terraform validate
	@echo "Validating prod environment..."
	cd envs/prod && terraform validate

format: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

lint: ## Run TFLint on all configurations
	@echo "Running TFLint on bootstrap..."
	cd bootstrap && tflint --config ../tools/.tflint.hcl
	@echo "Running TFLint on dev environment..."
	cd envs/dev && tflint --config ../../tools/.tflint.hcl
	@echo "Running TFLint on stage environment..."
	cd envs/stage && tflint --config ../../tools/.tflint.hcl
	@echo "Running TFLint on prod environment..."
	cd envs/prod && tflint --config ../../tools/.tflint.hcl

security: ## Run security scan with TFSec
	@echo "Running TFSec security scan..."
	tfsec --config-file tools/tfsec-excludes.yml

cost: ## Estimate infrastructure costs
	@echo "Estimating costs..."
	infracost breakdown --config-file tools/infracost.yml

# Secret management
encrypt-dev: ## Encrypt development secrets
	sops -e -i secrets/dev.tfvars

encrypt-stage: ## Encrypt staging secrets
	sops -e -i secrets/stage.tfvars

encrypt-prod: ## Encrypt production secrets
	sops -e -i secrets/prod.tfvars

decrypt-dev: ## Decrypt development secrets
	sops -d secrets/dev.tfvars

decrypt-stage: ## Decrypt staging secrets
	sops -d secrets/stage.tfvars

decrypt-prod: ## Decrypt production secrets
	sops -d secrets/prod.tfvars

# Cleanup
clean: ## Clean Terraform files
	@echo "Cleaning Terraform files..."
	find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name ".terraform.lock.hcl" -type f -delete 2>/dev/null || true
	find . -name "*.tfplan" -type f -delete 2>/dev/null || true
	find . -name "*.tfstate*" -type f -delete 2>/dev/null || true

# CI/CD helpers
ci-validate: ## Run all validations for CI
	@echo "Running CI validations..."
	$(MAKE) format
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) validate

ci-plan: ## Run plan for all environments
	@echo "Running CI plans..."
	$(MAKE) plan-dev
	$(MAKE) plan-stage
	$(MAKE) plan-prod

# Development helpers
dev-setup: ## Set up development environment
	@echo "Setting up development environment..."
	$(MAKE) install
	$(MAKE) bootstrap-init
	$(MAKE) bootstrap-apply
	$(MAKE) init-dev
	@echo "Development environment ready!"

# All environments
all-init: init-dev init-stage init-prod ## Initialize all environments
all-plan: plan-dev plan-stage plan-prod ## Plan all environments
all-validate: validate ## Validate all environments

# Show current status
status: ## Show current infrastructure status
	@echo "Bootstrap status:"
	cd bootstrap && terraform show -json | jq -r '.values.root_module.resources[] | select(.type == "aws_s3_bucket") | .values.bucket'
	@echo "Dev environment status:"
	cd envs/dev && terraform show -json | jq -r '.values.root_module.resources[] | .address' 2>/dev/null || echo "Not initialized"
	@echo "Stage environment status:"
	cd envs/stage && terraform show -json | jq -r '.values.root_module.resources[] | .address' 2>/dev/null || echo "Not initialized"
	@echo "Prod environment status:"
	cd envs/prod && terraform show -json | jq -r '.values.root_module.resources[] | .address' 2>/dev/null || echo "Not initialized"
