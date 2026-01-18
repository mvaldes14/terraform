# Migration Example: Moving from inline resources to module
#
# This file demonstrates how to migrate existing GitHub repository resources
# to the new module-based structure using Terraform's `moved` blocks.
#
# IMPORTANT: This is an EXAMPLE. You must customize it for your specific resources.

# Step 1: Define your repositories using the module
# This replaces the old inline github_repository resources

locals {
  repositories = {
    "meal-notifier" = {
      name       = "meal-notifier"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
      secrets    = true
    }
    "k8s-apps" = {
      name       = "k8s-apps"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
      secrets    = false
    }
    # Add more repositories as needed...
  }

  # Repositories that need secrets
  repos_with_secrets = {
    for name, config in local.repositories :
    name => config if config.secrets == true
  }
}

# Step 2: Use the module for all repositories
module "repositories" {
  for_each = local.repositories
  source   = "../../"  # Adjust path as needed

  repository_name  = each.key
  visibility       = each.value.visibility
  topics           = each.value.topics
  license_template = each.value.license

  # Configure webhook for all repositories
  webhook_url    = var.gh_discord_url
  webhook_events = ["*"]

  # Add secrets only for specified repositories
  actions_secrets = each.value.secrets ? {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    TELEGRAM_TOKEN     = var.telegram_token
    TELEGRAM_TO        = var.telegram_to
  } : {}
}

# Step 3: Add moved blocks to prevent resource recreation
# These blocks tell Terraform that the resources have moved, not been replaced

# Move repository resources from inline to module
moved {
  from = github_repository.repo["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_repository.repo
}

moved {
  from = github_repository.repo["k8s-apps"]
  to   = module.repositories["k8s-apps"].github_repository.repo
}

moved {
  from = github_repository.repo["ansible_playbooks"]
  to   = module.repositories["ansible_playbooks"].github_repository.repo
}

moved {
  from = github_repository.repo["dotfiles"]
  to   = module.repositories["dotfiles"].github_repository.repo
}

moved {
  from = github_repository.repo["chef"]
  to   = module.repositories["chef"].github_repository.repo
}

moved {
  from = github_repository.repo["pulumi"]
  to   = module.repositories["pulumi"].github_repository.repo
}

moved {
  from = github_repository.repo["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_repository.repo
}

moved {
  from = github_repository.repo["dotfiles-nix"]
  to   = module.repositories["dotfiles-nix"].github_repository.repo
}

moved {
  from = github_repository.repo["linear.nvim"]
  to   = module.repositories["linear.nvim"].github_repository.repo
}

moved {
  from = github_repository.repo["todoist.nvim"]
  to   = module.repositories["todoist.nvim"].github_repository.repo
}

moved {
  from = github_repository.repo["gh-actions"]
  to   = module.repositories["gh-actions"].github_repository.repo
}

moved {
  from = github_repository.repo["k8s-lsp"]
  to   = module.repositories["k8s-lsp"].github_repository.repo
}

moved {
  from = github_repository.repo["otel-collector"]
  to   = module.repositories["otel-collector"].github_repository.repo
}

moved {
  from = github_repository.repo["wiki"]
  to   = module.repositories["wiki"].github_repository.repo
}

# Move webhook resources from inline to module
moved {
  from = github_repository_webhook.wh["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["k8s-apps"]
  to   = module.repositories["k8s-apps"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["ansible_playbooks"]
  to   = module.repositories["ansible_playbooks"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["dotfiles"]
  to   = module.repositories["dotfiles"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["chef"]
  to   = module.repositories["chef"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["pulumi"]
  to   = module.repositories["pulumi"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["dotfiles-nix"]
  to   = module.repositories["dotfiles-nix"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["linear.nvim"]
  to   = module.repositories["linear.nvim"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["todoist.nvim"]
  to   = module.repositories["todoist.nvim"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["gh-actions"]
  to   = module.repositories["gh-actions"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["k8s-lsp"]
  to   = module.repositories["k8s-lsp"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["otel-collector"]
  to   = module.repositories["otel-collector"].github_repository_webhook.webhook[0]
}

moved {
  from = github_repository_webhook.wh["wiki"]
  to   = module.repositories["wiki"].github_repository_webhook.webhook[0]
}

# Move secrets for repositories that have them
# Note: The old structure had separate resources for each secret type
# The new module combines them into a single resource with for_each

moved {
  from = github_actions_secret.dockerhub_token["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}

moved {
  from = github_actions_secret.dockerhub_username["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_USERNAME"]
}

moved {
  from = github_actions_secret.telegram_chat["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["TELEGRAM_TOKEN"]
}

moved {
  from = github_actions_secret.telegram_to["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["TELEGRAM_TO"]
}

moved {
  from = github_actions_secret.dockerhub_token["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}

moved {
  from = github_actions_secret.dockerhub_username["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["DOCKERHUB_USERNAME"]
}

moved {
  from = github_actions_secret.telegram_chat["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["TELEGRAM_TOKEN"]
}

moved {
  from = github_actions_secret.telegram_to["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["TELEGRAM_TO"]
}

# Variables (these should already exist in your configuration)
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
