# GitHub Repository Module

This Terraform module creates and manages a GitHub repository with configurable settings, secrets, webhooks, and branch protection.

## Features

- Repository creation with customizable settings
- GitHub Actions secrets management
- Webhook configuration
- Branch protection rules
- Support for repository templates
- Automatic vulnerability alerts
- Issues, discussions, projects, and wiki configuration

## Usage

### Basic Example

```hcl
module "my_repo" {
  source = "../../modules/github-repo"

  repository_name = "my-awesome-project"
  description     = "An awesome project built with Terraform"
  visibility      = "public"
  topics          = ["terraform", "automation", "github"]
  license_template = "MIT"
}
```

### Advanced Example with Secrets and Webhook

```hcl
module "my_repo" {
  source = "../../modules/github-repo"

  repository_name              = "my-awesome-project"
  description                  = "An awesome project built with Terraform"
  visibility                   = "public"
  topics                       = ["terraform", "automation", "github"]
  license_template             = "MIT"
  enable_vulnerability_alerts  = true
  enable_issues                = true
  enable_wiki                  = true

  # GitHub Actions Secrets
  actions_secrets = {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    TELEGRAM_TOKEN     = var.telegram_token
  }

  # Webhook Configuration
  webhook_url          = var.discord_webhook_url
  webhook_active       = true
  webhook_content_type = "json"
  webhook_events       = ["push", "pull_request", "issues"]
}
```

### Example with Branch Protection

```hcl
module "protected_repo" {
  source = "../../modules/github-repo"

  repository_name = "production-app"
  description     = "Production application repository"
  visibility      = "private"

  # Branch Protection
  enable_branch_protection         = true
  branch_protection_pattern        = "main"
  required_approving_review_count  = 2
  require_code_owner_reviews       = true
  dismiss_stale_reviews            = true
  require_up_to_date_before_merge  = true
  required_status_checks           = ["ci/build", "ci/test"]
  enforce_admins                   = true
}
```

### Example with Template Repository

```hcl
module "templated_repo" {
  source = "../../modules/github-repo"

  repository_name = "new-project-from-template"
  description     = "New project created from a template"

  template_repository = {
    owner                = "my-org"
    repository           = "project-template"
    include_all_branches = false
  }
}
```

### Multiple Repositories Example

```hcl
locals {
  repositories = {
    "meal-notifier" = {
      description = "Meal notification automation"
      topics      = ["automation", "notifications"]
    }
    "k8s-apps" = {
      description = "Kubernetes applications"
      topics      = ["kubernetes", "homelab"]
    }
  }
}

module "repos" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name = each.key
  description     = each.value.description
  topics          = each.value.topics
  visibility      = "public"
  license_template = "MIT"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| repository_name | The name of the repository | string | n/a | yes |
| description | A description of the repository | string | "" | no |
| visibility | The visibility of the repository (public, private, or internal) | string | "public" | no |
| topics | A list of topics for the repository | list(string) | [] | no |
| license_template | The license template to use | string | "MIT" | no |
| enable_vulnerability_alerts | Enable vulnerability alerts | bool | true | no |
| enable_issues | Enable issues | bool | true | no |
| enable_discussions | Enable discussions | bool | false | no |
| enable_projects | Enable projects | bool | false | no |
| enable_wiki | Enable wiki | bool | false | no |
| auto_init | Initialize with a README.md | bool | false | no |
| gitignore_template | The gitignore template to use | string | "" | no |
| homepage_url | The homepage URL | string | "" | no |
| archived | Whether the repository is archived | bool | false | no |
| archive_on_destroy | Archive instead of deleting on destroy | bool | true | no |
| template_repository | Template repository configuration | object | null | no |
| actions_secrets | GitHub Actions secrets map | map(string) | {} | no |
| webhook_url | The URL for the webhook | string | "" | no |
| webhook_active | Whether the webhook is active | bool | true | no |
| webhook_content_type | The content type for the webhook | string | "json" | no |
| webhook_insecure_ssl | Allow insecure SSL | bool | false | no |
| webhook_secret | The secret for the webhook | string | "" | no |
| webhook_events | Events to trigger the webhook | list(string) | ["push"] | no |
| enable_branch_protection | Enable branch protection | bool | false | no |
| branch_protection_pattern | The branch pattern to protect | string | "main" | no |
| dismiss_stale_reviews | Dismiss stale reviews | bool | true | no |
| require_code_owner_reviews | Require code owner reviews | bool | false | no |
| required_approving_review_count | Number of required reviews | number | 1 | no |
| require_up_to_date_before_merge | Require up-to-date branches | bool | false | no |
| required_status_checks | Required status checks | list(string) | [] | no |
| enforce_admins | Enforce restrictions for admins | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_id | The ID of the repository |
| repository_node_id | The Node ID of the repository |
| repository_name | The name of the repository |
| repository_full_name | The full name (owner/repo) |
| repository_html_url | The HTML URL |
| repository_ssh_clone_url | The SSH clone URL |
| repository_http_clone_url | The HTTP clone URL |
| repository_git_clone_url | The Git clone URL |
| repository_visibility | The visibility |
| repository_topics | The topics |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| github | ~> 6.0 |

## License

MIT
