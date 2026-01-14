locals {
  repositories = {
    "meal-notifier" = {
      name       = "meal-notifier"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "k8s-apps" = {
      name       = "k8s-apps"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "ansible_playbooks" = {
      name       = "ansible_playbooks"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "dotfiles" = {
      name       = "dotfiles"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "chef" = {
      name       = "chef"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "pulumi" = {
      name       = "pulumi"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "twitch-bot" = {
      name       = "twitch-bot"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "dotfiles-nix" = {
      name       = "dotfiles-nix"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "linear.nvim" = {
      name       = "linear.nvim"
      license    = "MIT"
      topics     = ["neovim"]
      visibility = "public"
    }
    "todoist.nvim" = {
      name       = "todoist.nvim"
      license    = "MIT"
      topics     = ["neovim"]
      visibility = "public"
    }
    "gh-actions" = {
      name       = "gh-actions"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "k8s-lsp" = {
      name       = "k8s-lsp"
      license    = "MIT"
      topics     = ["neovim"]
      visibility = "public"
    }
    "otel-collector" = {
      name       = "otel-collector"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "wiki" = {
      name       = "wiki"
      license    = "MIT"
      topics     = ["personal"]
      visibility = "private"
    }
  }
  repo_with_secrets = toset(["meal-notifier", "twitch-bot"])
}
