variable "grafana_api_token" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "clickhouse_password" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "twitch_client_id" {
  type      = string
  sensitive = true
}

variable "twitch_oauth_token" {
  type      = string
  sensitive = true
}

variable "gotify_token" {
  type      = string
  sensitive = true
}
