variable "dockerhub_token" {
  type      = string
  sensitive = true
}

variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "gh_discord_url" {
  type      = string
  sensitive = true
  default   = ""
}
