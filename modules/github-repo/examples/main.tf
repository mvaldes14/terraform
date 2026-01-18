# Example usage of the github-repo module
# This example demonstrates how to migrate from the existing apps/github configuration

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Define repositories using the module
locals {
  repositories = {
    "meal-notifier" = {
      description = "Meal notification automation"
      topics      = ["automation"]
      visibility  = "public"
      secrets     = true
    }
    "k8s-apps" = {
      description = "Kubernetes applications for homelab"
      topics      = ["homelab", "kubernetes"]
      visibility  = "public"
      secrets     = false
    }
    "ansible_playbooks" = {
      description = "Ansible automation playbooks"
      topics      = ["automation", "ansible"]
      visibility  = "public"
      secrets     = false
    }
    "dotfiles" = {
      description = "Personal dotfiles configuration"
      topics      = ["homelab", "dotfiles"]
      visibility  = "public"
      secrets     = false
    }
    "linear.nvim" = {
      description = "Linear integration for Neovim"
      topics      = ["neovim", "plugin"]
      visibility  = "public"
      secrets     = false
    }
    "todoist.nvim" = {
      description = "Todoist integration for Neovim"
      topics      = ["neovim", "plugin"]
      visibility  = "public"
      secrets     = false
    }
    "k8s-lsp" = {
      description = "Kubernetes Language Server Protocol"
      topics      = ["neovim", "kubernetes", "lsp"]
      visibility  = "public"
      secrets     = false
    }
    "otel-collector" = {
      description = "OpenTelemetry collector configuration"
      topics      = ["homelab", "observability"]
      visibility  = "public"
      secrets     = false
    }
    "wiki" = {
      description = "Personal knowledge base and wiki"
      topics      = ["personal", "documentation"]
      visibility  = "private"
      secrets     = false
    }
  }

  # Repositories that need secrets
  repos_with_secrets = {
    for name, config in local.repositories :
    name => config if config.secrets == true
  }
}

# Create repositories using the module
module "repositories" {
  for_each = local.repositories
  source   = "../.."  # Adjust path as needed

  repository_name              = each.key
  description                  = each.value.description
  visibility                   = each.value.visibility
  topics                       = each.value.topics
  license_template             = "MIT"
  enable_vulnerability_alerts  = true
  enable_issues                = true
  enable_wiki                  = false

  # Configure webhook for all repositories
  webhook_url          = var.gh_discord_url
  webhook_active       = true
  webhook_content_type = "json"
  webhook_events       = ["*"]

  # Add secrets only for specified repositories
  actions_secrets = each.value.secrets ? {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    TELEGRAM_TOKEN     = var.telegram_token
    TELEGRAM_TO        = var.telegram_to
  } : {}
}

# Variables (these should match your existing variables)
variable "dockerhub_token" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "telegram_token" {
  type      = string
  sensitive = true
}

variable "telegram_to" {
  type      = string
  sensitive = true
}

variable "gh_discord_url" {
  type      = string
  sensitive = true
  default   = ""
}

# Outputs
output "repositories" {
  description = "Created repositories information"
  value = {
    for name, repo in module.repositories :
    name => {
      id        = repo.repository_id
      html_url  = repo.repository_html_url
      clone_url = repo.repository_ssh_clone_url
    }
  }
}

output "repository_urls" {
  description = "Map of repository names to their HTML URLs"
  value = {
    for name, repo in module.repositories :
    name => repo.repository_html_url
  }
}
