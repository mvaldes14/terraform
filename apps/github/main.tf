resource "github_repository" "repo" {
  for_each             = local.repositories
  name                 = each.key
  visibility           = each.value.visibility
  topics               = tolist(each.value.topics)
  license_template     = each.value.license
  vulnerability_alerts = true
}

resource "github_actions_secret" "dockerhub_token" {
  for_each        = toset(local.repo_with_docker)
  repository      = each.key
  secret_name     = "DOCKERHUB_TOKEN"
  plaintext_value = var.dockerhub_token
}

resource "github_actions_secret" "dockerhub_username" {
  for_each        = toset(local.repo_with_docker)
  repository      = each.key
  secret_name     = "DOCKERHUB_USERNAME"
  plaintext_value = var.dockerhub_username
}

resource "github_actions_secret" "telegram_chat" {
  repository      = "ansible_playbooks"
  secret_name     = "TELEGRAM_TOKEN"
  plaintext_value = var.telegram_token
}

resource "github_actions_secret" "telegram_to" {
  repository      = "ansible_playbooks"
  secret_name     = "TELEGRAM_TO"
  plaintext_value = var.telegram_to
}

resource "github_actions_secret" "ansible_vault_password" {
  repository      = "ansible_playbooks"
  secret_name     = "ANSIBLE_VAULT_PASSWORD"
  plaintext_value = var.ansible_vault_password
}
