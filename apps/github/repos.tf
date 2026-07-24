# GitHub Repository Management using Module
# This file replaces the inline resources with the github-repo module
# and includes moved blocks to prevent resource recreation

# Add a repository by appending an entry to this map (key = repo name).
locals {
  repositories = {
    "meal-notifier" = {
      name                     = "meal-notifier"
      license                  = "MIT"
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = true
    }
    "k8s-apps" = {
      name                     = "k8s-apps"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "ansible_playbooks" = {
      name                     = "ansible_playbooks"
      license                  = "MIT"
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "dotfiles" = {
      name                     = "dotfiles"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "chef" = {
      name                     = "chef"
      license                  = "MIT"
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "pulumi" = {
      name                     = "pulumi"
      license                  = "MIT"
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "twitch-bot" = {
      name                     = "twitch-bot"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = true
    }
    "dotfiles-nix" = {
      name                     = "dotfiles-nix"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "linear.nvim" = {
      name                     = "linear.nvim"
      license                  = "MIT"
      topics                   = ["neovim"]
      visibility               = "public"
      enable_dockerhub_secrets = false
      archived                 = true
    }
    "todoist.nvim" = {
      name                     = "todoist.nvim"
      license                  = "MIT"
      topics                   = ["neovim"]
      visibility               = "public"
      enable_dockerhub_secrets = false
      archived                 = true
    }
    "gh-actions" = {
      name                     = "gh-actions"
      license                  = "MIT"
      topics                   = ["automation"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "k8s-lsp" = {
      name                     = "k8s-lsp"
      license                  = "MIT"
      topics                   = ["neovim"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "otel-collector" = {
      name                     = "otel-collector"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "dotfiles-vorpal" = {
      name                     = "dotfiles-vorpal"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "task-manager" = {
      name                     = "task-manager"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = true
    }
    "task-manager-mcp" = {
      name                     = "task-manager-mcp"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = true
    }
    "homelab-tf-provider" = {
      name                     = "homelab-tf-provider"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "chi" = {
      name                     = "chi"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "private"
      enable_dockerhub_secrets = false
    }
    "shorts" = {
      name                     = "shorts"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "private"
      enable_dockerhub_secrets = false
    }
    "nerv" = {
      name                     = "nerv"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "public"
      enable_dockerhub_secrets = false
    }
    "homelab-events" = {
      name                     = "homelab-events"
      license                  = "MIT"
      topics                   = ["homelab"]
      visibility               = "private"
      enable_dockerhub_secrets = false
    }
  }
}

# Use the module for all repositories
module "repositories" {
  for_each = local.repositories
  source   = "git::https://github.com/mvaldes14/terraform.git//modules/github-repo?ref=main"

  repository_name  = each.key
  visibility       = each.value.visibility
  topics           = each.value.topics
  license_template = each.value.license

  # Configure webhook for all repositories
  webhook_url    = var.gh_discord_url
  webhook_events = ["*"]

  # Add DockerHub secrets if enabled for this repository
  enable_dockerhub_secrets = lookup(each.value, "enable_dockerhub_secrets", false)
  dockerhub_token          = var.dockerhub_token
  dockerhub_username       = var.dockerhub_username
}
