resource "grafana_data_source" "github" {
  type = "grafana-github-datasource"
  name = "Github"
  json_data_encoded = jsonencode({
    owner = ""
  })
  secure_json_data_encoded = jsonencode({
    accessToken = var.github_token
  })
}

resource "grafana_data_source" "clickhouse" {
  type       = "grafana-clickhouse-datasource"
  name       = "Clickhouse"
  is_default = true
  json_data_encoded = jsonencode({
    default_database = "default"
    host             = "ck-cluster-clickhouse-headless.clickhouse"
    port             = 9000
    protocol         = "native"
  })
  secure_json_data_encoded = jsonencode({
    password = var.clickhouse_password
  })
}

resource "grafana_data_source" "postgresql" {
  type     = "postgres"
  name     = "Postgres"
  url      = "homelab-db-ro.db:5432"
  username = "admin"
  secure_json_data_encoded = jsonencode({
    password = var.postgres_password
  })
  json_data_encoded = jsonencode({
    database = "personal"
    sslmode  = "disable"
  })
}

resource "grafana_data_source" "redis" {
  type = "redis-datasource"
  name = "Redis"
  url  = "redis://redis-svc.db:6379"
}

resource "grafana_data_source" "twitch-api" {
  type = "yesoreyeram-infinity-datasource"
  name = "Twitch-API"
  url  = "https://api.twitch.tv/helix"
  http_headers = {
    "Client-ID"     = var.twitch_client_id
    "Authorization" = "Bearer ${var.twitch_oauth_token}"
  }
  json_data_encoded = jsonencode({
    allowedHosts = ["https://api.twitch.tv/helix"]
  })
}
