terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "github_repository" "repo" {
  for_each = local.repositories
  name = each.key
  visibility = each.value.visibility
  topics = tolist(each.value.topics)
  license_template = each.value.license
  vulnerability_alerts = true
}
