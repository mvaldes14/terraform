locals {
  repositories = {
    "meal-notifier" = {
      name       = "meal-notifier"
      private    = false
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "k8s-apps" = {
      name       = "k8s-apps"
      private    = false
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "ansible_playbooks" = {
      name       = "ansible_playbooks"
      private    = false
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "dotfiles" = {
      name       = "dotfiles"
      private    = false
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "chef" = {
      name       = "chef"
      private    = false
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "pulumi" = {
      name       = "pulumi"
      private    = false
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
    "twitch-bot" = {
      name       = "twitch-bot"
      private    = false
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "dotfiles-nix" = {
      name       = "dotfiles-nix"
      private    = "false"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "deckmaster-config" = {
      name       = "deckmaster-config"
      private    = "false"
      license    = "MIT"
      topics     = ["homelab"]
      visibility = "public"
    }
    "linear.nvim" = {
      name       = "linear.nvim"
      private    = "false"
      license    = "MIT"
      topics     = ["neovim"]
      visibility = "public"
    }
    "todoist.nvim" = {
      name       = "todoist.nvim"
      private    = "false"
      license    = "MIT"
      topics     = ["neovim"]
      visibility = "public"
    }
    "flakes" = {
      name       = "flakes"
      private    = "false"
      license    = "MIT"
      topics     = ["nix"]
      visibility = "public"
    }
  }
  repo_with_secrets = toset(["meal-notifier", "twitch-bot"])
}
