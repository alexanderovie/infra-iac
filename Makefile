SHELL := /bin/bash

.PHONY: op-login op-check tf-migrate-1password tf-init tf-plan tf-apply tf-validate tf-state tf-fmt tf-sh

# 1Password CLI v2 commands
op-login:
	@echo "→ Signin 1Password CLI v2"
	@eval $$(op signin) && op whoami

op-check:
	@op whoami && op vault list

# 1Password migration
tf-migrate-1password:
	./scripts/1password-migrate.sh

# Terraform commands with 1Password CLI v2
tf-init:
	@op run --env-file=<(source scripts/export-env-1password.sh) -- terraform init -upgrade

tf-plan:
	@op run --env-file=<(source scripts/export-env-1password.sh) -- terraform plan

tf-apply:
	@op run --env-file=<(source scripts/export-env-1password.sh) -- terraform apply -auto-approve

tf-validate:
	@op run --env-file=<(source scripts/export-env-1password.sh) -- terraform validate

tf-state:
	@op run --env-file=<(source scripts/export-env-1password.sh) -- terraform state list || true

tf-fmt:
	@terraform fmt -recursive

tf-sh:
	@bash
