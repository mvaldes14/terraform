resource "github_repository" "repo" {
  for_each             = local.repositories
  name                 = each.key
  visibility           = each.value.visibility
  topics               = tolist(each.value.topics)
  license_template     = each.value.license
  vulnerability_alerts = true
}

resource "github_actions_secret" "dockerhub_token" {
  for_each        = local.repo_with_secrets
  repository      = each.key
  secret_name     = "DOCKERHUB_TOKEN"
  plaintext_value = var.dockerhub_token
}

resource "github_actions_secret" "dockerhub_username" {
  for_each        = local.repo_with_secrets
  repository      = each.key
  secret_name     = "DOCKERHUB_USERNAME"
  plaintext_value = var.dockerhub_username
}

resource "github_actions_secret" "telegram_chat" {
  for_each        = local.repo_with_secrets
  repository      = each.key
  secret_name     = "TELEGRAM_TOKEN"
  plaintext_value = var.telegram_token
}

resource "github_actions_secret" "telegram_to" {
  for_each        = local.repo_with_secrets
  repository      = each.key
  secret_name     = "TELEGRAM_TO"
  plaintext_value = var.telegram_to
}

resource "github_repository_webhook" "wh" {
  for_each   = local.repositories
  repository = each.key
  active     = false
  configuration {
    url          = "https://automate.mvaldes.dev/webhook/gh"
    content_type = "json"
    insecure_ssl = false
  }
  events = ["push", "pull_request"]
}
