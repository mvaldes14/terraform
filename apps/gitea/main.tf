terraform {
  required_providers {
    gitea = {
      source = "go-gitea/gitea"
      version = "0.3.0"
    }
  }
}

provider "gitea" {
    insecure = false
}

resource "gitea_repository" "this" {
  for_each = local.repositories

  username     = each.value.username
  name         = each.key
  private      = each.value.private
  gitignores   = each.value.git_template
}
