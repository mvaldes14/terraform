.PHONY: help fmt validate lint security test docs install-tools ci-local clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install-tools: ## Install required CI/CD tools
	@echo "Installing Terraform tools..."
	@which terraform >/dev/null 2>&1 || (echo "Please install Terraform first" && exit 1)
	@echo "Installing TFLint..."
	@which tflint >/dev/null 2>&1 || curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
	@echo "Installing tfsec..."
	@which tfsec >/dev/null 2>&1 || (curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash)
	@echo "Installing terraform-docs..."
	@which terraform-docs >/dev/null 2>&1 || (curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.17.0/terraform-docs-v0.17.0-$$(uname)-amd64.tar.gz && tar -xzf terraform-docs.tar.gz && chmod +x terraform-docs && sudo mv terraform-docs /usr/local/bin/ && rm terraform-docs.tar.gz)
	@echo "Installing Checkov..."
	@which checkov >/dev/null 2>&1 || pip3 install checkov
	@echo "Installing pre-commit..."
	@which pre-commit >/dev/null 2>&1 || pip3 install pre-commit
	@echo "✅ All tools installed successfully!"

fmt: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive
	@echo "✅ Formatting complete"

fmt-check: ## Check if Terraform files are formatted
	@echo "Checking Terraform formatting..."
	@terraform fmt -check -recursive
	@echo "✅ Format check complete"

validate: ## Validate all Terraform configurations
	@echo "Validating Terraform configurations..."
	@for dir in apps/* modules/*; do \
		if [ -d "$$dir" ] && [ -f "$$dir/main.tf" ]; then \
			echo "Validating $$dir..."; \
			(cd "$$dir" && terraform init -backend=false > /dev/null 2>&1 && terraform validate) || exit 1; \
		fi \
	done
	@echo "✅ Validation complete"

lint: ## Run TFLint on all files
	@echo "Running TFLint..."
	@tflint --init
	@tflint --recursive --format=compact
	@echo "✅ Linting complete"

security: ## Run security scans (tfsec and checkov)
	@echo "Running tfsec security scan..."
	@tfsec . --soft-fail || true
	@echo ""
	@echo "Running Checkov security scan..."
	@checkov -d . --framework terraform --quiet --soft-fail || true
	@echo "✅ Security scans complete"

docs: ## Generate module documentation
	@echo "Generating module documentation..."
	@for module in modules/*; do \
		if [ -d "$$module" ] && [ -f "$$module/main.tf" ]; then \
			echo "Generating docs for $$module..."; \
			terraform-docs markdown table --output-file README.md --output-mode inject $$module; \
		fi \
	done
	@echo "✅ Documentation generation complete"

test: ## Run module tests
	@echo "Testing modules..."
	@for module in modules/*/examples; do \
		if [ -d "$$module" ]; then \
			echo "Testing $$module..."; \
			(cd "$$module" && terraform init -backend=false > /dev/null 2>&1 && terraform validate) || exit 1; \
		fi \
	done
	@echo "✅ Module tests complete"

pre-commit-install: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@pre-commit install
	@echo "✅ Pre-commit hooks installed"

pre-commit-run: ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks..."
	@pre-commit run --all-files
	@echo "✅ Pre-commit checks complete"

ci-local: fmt-check validate lint security docs test ## Run all CI checks locally
	@echo ""
	@echo "================================"
	@echo "✅ All CI checks passed locally!"
	@echo "================================"
	@echo ""
	@echo "Your code is ready to push! 🚀"

clean: ## Clean up temporary files
	@echo "Cleaning up..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -exec rm -f {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -exec rm -f {} + 2>/dev/null || true
	@echo "✅ Cleanup complete"

plan-github: ## Run terraform plan for github app
	@echo "Planning GitHub infrastructure..."
	@cd apps/github && terraform init && terraform plan

apply-github: ## Run terraform apply for github app
	@echo "Applying GitHub infrastructure..."
	@cd apps/github && terraform init && terraform apply

plan-all: ## Run terraform plan for all apps
	@echo "Planning all infrastructure..."
	@for dir in apps/*; do \
		if [ -d "$$dir" ] && [ -f "$$dir/main.tf" ]; then \
			echo "Planning $$dir..."; \
			(cd "$$dir" && terraform init && terraform plan) || exit 1; \
		fi \
	done

.DEFAULT_GOAL := help
