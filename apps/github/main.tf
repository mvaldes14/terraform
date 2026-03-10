# GitHub Repository Management using Module
# This file replaces the inline resources with the github-repo module
# and includes moved blocks to prevent resource recreation

# Use the module for all repositories
module "repositories" {
  for_each = local.repositories
  source   = "git::https://github.com/mvaldes14/terraform.git//modules/github-repo?ref=main"

  repository_name  = each.key
  visibility       = each.value.visibility
  topics           = each.value.topics
  license_template = each.value.license

  # Configure webhook for all repositories
  webhook_url    = var.gh_discord_url
  webhook_events = ["*"]

  # Add DockerHub secrets if enabled for this repository
  enable_dockerhub_secrets = lookup(each.value, "enable_dockerhub_secrets", false)
  dockerhub_token          = var.dockerhub_token
  dockerhub_username       = var.dockerhub_username
}

