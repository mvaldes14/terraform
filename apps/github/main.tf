terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "github_repository" "meal-notifier" {
  for_each = local.repositories

  name = each.key
  visibility = each.value.visibility
  gitignore_template = each.value.git_template
  topics = each.value.topics
  vulnerability_alerts = true

}
