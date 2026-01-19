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
    }
    "todoist.nvim" = {
      name                     = "todoist.nvim"
      license                  = "MIT"
      topics                   = ["neovim"]
      visibility               = "public"
      enable_dockerhub_secrets = false
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
    "wiki" = {
      name                     = "wiki"
      license                  = "MIT"
      topics                   = ["personal"]
      visibility               = "private"
      enable_dockerhub_secrets = false
    }
  }
}
