# Example usage of the github-repo module

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
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = true
    }
    "k8s-apps" = {
      topics                   = ["homelab", "kubernetes"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "linear.nvim" = {
      topics                   = ["neovim", "plugin"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "wiki" = {
      topics                   = ["personal", "documentation"]
      visibility               = "private"
      enable_dockerhub_secrets = false
    }
  }
}

# Create repositories using the module
module "repositories" {
  for_each = local.repositories
  source   = "../.."  # Adjust path as needed

  repository_name  = each.key
  visibility       = each.value.visibility
  topics           = each.value.topics
  license_template = "MIT"

  # Configure webhook for all repositories
  webhook_url    = var.gh_discord_url
  webhook_events = ["*"]

  # Add DockerHub secrets if enabled for this repository
  actions_secrets = lookup(each.value, "enable_dockerhub_secrets", false) ? {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
  } : {}
}

# Variables
variable "dockerhub_token" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
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
