# Terraform Repository Structure and Usage Guide

This document provides a comprehensive guide to the repository structure, module usage, and development patterns for this Terraform project.

## Repository Overview

This repository contains Terraform configurations for managing homelab infrastructure, cloud resources, and GitHub repositories. It follows a modular architecture separating reusable modules from application-specific configurations.

## Directory Structure

```
terraform/
├── apps/                    # Application-specific Terraform configurations
│   ├── aws/                 # AWS infrastructure
│   ├── aws_localstack/      # LocalStack AWS emulation
│   ├── containers/          # Container deployments
│   ├── demo/                # Demo/testing configurations
│   └── github/              # GitHub repository management
│       ├── main.tf          # Repository resources
│       ├── locals.tf        # Local variable definitions
│       ├── variables.tf     # Input variables
│       ├── providers.tf     # Provider configuration
│       ├── state.tf         # State backend configuration
│       └── data.tf          # Data sources
│
├── modules/                 # Reusable Terraform modules
│   ├── containers/          # Docker container module
│   ├── localstack/          # LocalStack modules
│   │   └── vpc/             # VPC configuration for LocalStack
│   └── github-repo/         # GitHub repository module (NEW)
│       ├── main.tf          # Module resources
│       ├── variables.tf     # Module input variables
│       ├── outputs.tf       # Module outputs
│       ├── versions.tf      # Provider version constraints
│       ├── README.md        # Module documentation
│       └── examples/        # Usage examples
│           ├── main.tf      # Example implementation
│           └── README.md    # Example documentation
│
├── README.md                # Main repository documentation
├── agents.md                # This file - structure and usage guide
├── atlantis.yaml            # Atlantis CI/CD configuration
├── devbox.json              # Development environment configuration
└── .envrc                   # Environment variables
```

## Architecture Patterns

### Apps vs Modules

**Apps (`apps/`)**: Application-specific configurations that:
- Deploy actual infrastructure
- Consume modules
- Manage state
- Define provider configurations
- Are environment-specific

**Modules (`modules/`)**: Reusable components that:
- Encapsulate resource logic
- Accept input via variables
- Provide outputs
- Are environment-agnostic
- Follow single-responsibility principle

### State Management

State is managed in a local MinIO S3 bucket. Each app has its own state file configured in `state.tf`:

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "apps/github/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Module Usage Guide

### GitHub Repository Module

The `github-repo` module provides a comprehensive interface for managing GitHub repositories.

#### Basic Usage

```hcl
module "my_repo" {
  source = "../../modules/github-repo"

  repository_name = "my-project"
  description     = "My awesome project"
  visibility      = "public"
  topics          = ["terraform", "automation"]
  license_template = "MIT"
}
```

#### Advanced Usage with Secrets

```hcl
module "app_repo" {
  source = "../../modules/github-repo"

  repository_name              = "my-app"
  description                  = "Production application"
  visibility                   = "private"
  topics                       = ["production", "nodejs"]
  license_template             = "MIT"
  enable_vulnerability_alerts  = true
  enable_issues                = true

  # GitHub Actions Secrets
  actions_secrets = {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    API_KEY            = var.api_key
  }

  # Webhook Configuration
  webhook_url          = var.discord_webhook_url
  webhook_active       = true
  webhook_content_type = "json"
  webhook_events       = ["push", "pull_request", "issues"]
}
```

#### Multiple Repositories Pattern

```hcl
locals {
  repositories = {
    "api-service" = {
      description = "REST API service"
      topics      = ["api", "nodejs"]
      visibility  = "private"
    }
    "web-frontend" = {
      description = "Web application frontend"
      topics      = ["frontend", "react"]
      visibility  = "public"
    }
  }
}

module "repositories" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name = each.key
  description     = each.value.description
  topics          = each.value.topics
  visibility      = each.value.visibility
  license_template = "MIT"
}
```

#### Branch Protection

```hcl
module "protected_repo" {
  source = "../../modules/github-repo"

  repository_name = "production-app"
  visibility      = "private"

  # Enable branch protection
  enable_branch_protection         = true
  branch_protection_pattern        = "main"
  required_approving_review_count  = 2
  require_code_owner_reviews       = true
  dismiss_stale_reviews            = true
  require_up_to_date_before_merge  = true
  required_status_checks           = ["ci/build", "ci/test"]
  enforce_admins                   = false
}
```

### Container Module

The `containers` module manages Docker containers:

```hcl
module "nginx" {
  source = "../../modules/containers"

  container_name     = "my-nginx"
  container_int_port = 80
  container_ext_port = 8080
}
```

### LocalStack VPC Module

```hcl
module "vpc" {
  source = "../../modules/localstack/vpc"

  # VPC configuration
}
```

## Development Workflow

### 1. Creating a New App

```bash
# Create app directory
mkdir -p apps/my-new-app

# Create standard files
cd apps/my-new-app
touch main.tf variables.tf providers.tf state.tf
```

**Standard `providers.tf`:**
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    # your providers here
  }
}
```

**Standard `state.tf`:**
```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "apps/my-new-app/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### 2. Creating a New Module

```bash
# Create module directory
mkdir -p modules/my-module

# Create standard files
cd modules/my-module
touch main.tf variables.tf outputs.tf versions.tf README.md
```

**Module File Structure:**
- `main.tf` - Resource definitions
- `variables.tf` - Input variables with descriptions and defaults
- `outputs.tf` - Output values
- `versions.tf` - Terraform and provider version constraints
- `README.md` - Module documentation
- `examples/` - Usage examples (optional but recommended)

### 3. Testing Changes

```bash
# Navigate to app directory
cd apps/my-app

# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### 4. Using Atlantis

This repository is configured for Atlantis CI/CD. The `atlantis.yaml` file defines workflows:

```bash
# Atlantis will automatically:
# - Run terraform plan on pull requests
# - Apply changes when approved and merged
```

## Best Practices

### Module Development

1. **Single Responsibility**: Each module should do one thing well
2. **Documentation**: Always include a comprehensive README.md
3. **Examples**: Provide usage examples in an `examples/` directory
4. **Variables**: Use descriptive names with clear descriptions
5. **Validation**: Add variable validation where appropriate
6. **Outputs**: Export useful information for consumers
7. **Versions**: Pin provider versions in `versions.tf`

### Variable Naming

- Use snake_case: `repository_name`, `enable_issues`
- Use prefixes for groups: `webhook_url`, `webhook_events`
- Boolean variables: start with `enable_`, `has_`, or `is_`

### Security

1. **Sensitive Variables**: Mark sensitive variables appropriately
   ```hcl
   variable "api_key" {
     type      = string
     sensitive = true
   }
   ```

2. **State Files**: Never commit state files to version control
3. **Secrets**: Use environment variables or secret management tools
4. **Archive on Destroy**: Set `archive_on_destroy = true` for repositories

### Code Organization

1. **Locals**: Use `locals.tf` for computed values and data transformation
2. **Data Sources**: Keep data sources in `data.tf`
3. **Resources**: Group related resources in `main.tf`
4. **Variables**: Separate input variables in `variables.tf`
5. **Outputs**: Separate outputs in `outputs.tf`

## Migration Guide

### Migrating from Inline Resources to Module

**Before (apps/github/main.tf):**
```hcl
resource "github_repository" "repo" {
  for_each   = local.repositories
  name       = each.key
  visibility = each.value.visibility
  topics     = each.value.topics
  # ... more configuration
}
```

**After (using module):**
```hcl
module "repositories" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name = each.key
  visibility      = each.value.visibility
  topics          = each.value.topics
  # ... more configuration
}
```

**Benefits:**
- Reusability across apps
- Centralized updates
- Better testing
- Clearer separation of concerns

## Common Patterns

### Conditional Resources

```hcl
module "repo" {
  source = "../../modules/github-repo"

  repository_name = "my-repo"

  # Webhook only if URL provided
  webhook_url = var.enable_webhook ? var.webhook_url : ""

  # Secrets only for specific repos
  actions_secrets = var.is_production ? var.prod_secrets : {}
}
```

### Dynamic Blocks

```hcl
# In module main.tf
dynamic "template" {
  for_each = var.template_repository != null ? [var.template_repository] : []
  content {
    owner      = template.value.owner
    repository = template.value.repository
  }
}
```

### For Each with Maps

```hcl
locals {
  repo_config = {
    app1 = { visibility = "public", topics = ["app"] }
    app2 = { visibility = "private", topics = ["internal"] }
  }
}

module "repos" {
  for_each = local.repo_config
  source   = "../../modules/github-repo"

  repository_name = each.key
  visibility      = each.value.visibility
  topics          = each.value.topics
}
```

## Troubleshooting

### Common Issues

1. **State Lock Issues**
   ```bash
   # Force unlock (use with caution)
   terraform force-unlock <LOCK_ID>
   ```

2. **Provider Authentication**
   ```bash
   # Set environment variables
   export GITHUB_TOKEN="your-token"
   export AWS_ACCESS_KEY_ID="your-key"
   export AWS_SECRET_ACCESS_KEY="your-secret"
   ```

3. **Module Not Found**
   ```bash
   # Reinitialize to download modules
   terraform init -upgrade
   ```

4. **State Drift**
   ```bash
   # Refresh state
   terraform refresh

   # Import existing resource
   terraform import module.repo.github_repository.repo my-repo-name
   ```

## Development Tools

### Required Tools

- Terraform >= 1.0
- Docker (for containers)
- LocalStack (for AWS emulation)
- Git

### Optional Tools

- `devbox` - Development environment management (configured in `devbox.json`)
- `atlantis` - Terraform pull request automation
- `tflint` - Terraform linter
- `terraform-docs` - Generate documentation from Terraform modules

### Environment Setup

```bash
# Using devbox
devbox shell

# Or manually
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export GITHUB_TOKEN="your-token"
```

## Resources

### Module Documentation

- [GitHub Repository Module](./modules/github-repo/README.md)
- [Container Module](./modules/containers/)
- [LocalStack VPC Module](./modules/localstack/vpc/)

### External References

- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [GitHub Provider Documentation](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [Terraform Module Development](https://developer.hashicorp.com/terraform/language/modules/develop)

## Contributing

When contributing to this repository:

1. Create a feature branch
2. Make your changes
3. Test thoroughly with `terraform plan`
4. Update documentation
5. Submit a pull request
6. Wait for Atlantis automation to run

## Questions and Support

For questions about:
- Module usage: Check the module's README.md
- Repository structure: Refer to this document
- Specific resources: Consult Terraform provider documentation
