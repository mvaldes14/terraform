terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

resource "github_repository" "repo" {
  name                 = var.repository_name
  description          = var.description
  visibility           = var.visibility
  topics               = var.topics
  license_template     = var.license_template
  vulnerability_alerts = var.enable_vulnerability_alerts
  has_issues           = var.enable_issues
  has_discussions      = var.enable_discussions
  has_projects         = var.enable_projects
  has_wiki             = var.enable_wiki
  auto_init            = var.auto_init
  gitignore_template   = var.gitignore_template
  homepage_url         = var.homepage_url
  archived             = var.archived
  archive_on_destroy   = var.archive_on_destroy

  dynamic "template" {
    for_each = var.template_repository != null ? [var.template_repository] : []
    content {
      owner                = template.value.owner
      repository           = template.value.repository
      include_all_branches = lookup(template.value, "include_all_branches", false)
    }
  }
}

resource "github_actions_secret" "secrets" {
  for_each        = var.actions_secrets
  repository      = github_repository.repo.name
  secret_name     = each.key
  plaintext_value = each.value

  depends_on = [github_repository.repo]
}

resource "github_repository_webhook" "webhook" {
  count      = var.webhook_url != "" ? 1 : 0
  repository = github_repository.repo.name
  active     = var.webhook_active

  configuration {
    url          = var.webhook_url
    content_type = var.webhook_content_type
    insecure_ssl = var.webhook_insecure_ssl
    secret       = var.webhook_secret
  }

  events = var.webhook_events

  depends_on = [github_repository.repo]
}

resource "github_branch_protection" "main" {
  count         = var.enable_branch_protection ? 1 : 0
  repository_id = github_repository.repo.node_id
  pattern       = var.branch_protection_pattern

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    require_code_owner_reviews      = var.require_code_owner_reviews
    required_approving_review_count = var.required_approving_review_count
  }

  required_status_checks {
    strict   = var.require_up_to_date_before_merge
    contexts = var.required_status_checks
  }

  enforce_admins = var.enforce_admins
}
