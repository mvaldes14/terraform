locals {
  repositories = {
    "dotfiles-nix" = {
      description     = ""
      private         = false
      actions_enabled = false
    }
    "dotfiles-vorpal" = {
      description     = ""
      private         = false
      actions_enabled = false
    }
  }
}

resource "forgejo_repository" "repository" {
  for_each = local.repositories

  name              = each.key
  description       = each.value.description
  private           = each.value.private
  default_branch    = "main"
  clone_addr        = "https://github.com/mvaldes14/${each.key}.git"
  mirror            = true
  mirror_interval   = "8h0m0s"
  enable_prune      = true
  has_actions       = each.value.actions_enabled
  has_issues        = true
  has_packages      = true
  has_projects      = true
  has_pull_requests = true
  has_releases      = true
  has_wiki          = true

  lifecycle {
    prevent_destroy = true
  }
}
