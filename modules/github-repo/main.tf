resource "github_repository" "repo" {
  name                 = var.repository_name
  visibility           = var.visibility
  topics               = var.topics
  license_template     = var.license_template
  vulnerability_alerts = true
  has_issues           = true
}

resource "github_actions_secret" "dockerhub_token" {
  count           = var.enable_dockerhub_secrets ? 1 : 0
  repository      = github_repository.repo.name
  secret_name     = "DOCKERHUB_TOKEN"
  plaintext_value = var.dockerhub_token

  depends_on = [github_repository.repo]
}

resource "github_actions_secret" "dockerhub_username" {
  count           = var.enable_dockerhub_secrets ? 1 : 0
  repository      = github_repository.repo.name
  secret_name     = "DOCKERHUB_USERNAME"
  plaintext_value = var.dockerhub_username

  depends_on = [github_repository.repo]
}

resource "github_repository_webhook" "webhook" {
  count      = var.webhook_url != "" ? 1 : 0
  repository = github_repository.repo.name
  active     = true

  configuration {
    url          = var.webhook_url
    content_type = "json"
    insecure_ssl = false
  }

  events = var.webhook_events

  depends_on = [github_repository.repo]
}
