# GitHub Repository Management using Module
# This file replaces the inline resources with the github-repo module
# and includes moved blocks to prevent resource recreation

# Use the module for all repositories
module "repositories" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name  = each.key
  visibility       = each.value.visibility
  topics           = each.value.topics
  license_template = each.value.license

  # Configure webhook for all repositories
  webhook_url    = var.gh_discord_url
  webhook_events = ["*"]

  # Add DockerHub secrets if enabled for this repository
  actions_secrets = lookup(each.value, "enable_dockerhub_secrets", false) ? {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
  } : {}
}

# ============================================================================
# MOVED BLOCKS - Migration from inline resources to module
# ============================================================================
# These blocks prevent resource destruction during migration.
# After successful terraform apply, these can be removed.

# Repository moves
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

# Webhook moves
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

# Secret moves for meal-notifier
moved {
  from = github_actions_secret.dockerhub_token["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}

moved {
  from = github_actions_secret.dockerhub_username["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_USERNAME"]
}

# Secret moves for twitch-bot
moved {
  from = github_actions_secret.dockerhub_token["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}

moved {
  from = github_actions_secret.dockerhub_username["twitch-bot"]
  to   = module.repositories["twitch-bot"].github_actions_secret.secrets["DOCKERHUB_USERNAME"]
}

# Note: blog repository secrets are managed separately in data.tf
# and would need their own migration strategy if converting to module
