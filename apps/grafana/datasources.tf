resource "grafana_data_source" "victoriametrics" {
  type       = "victoriametrics-metrics-datasource"
  url        = "http://victoriametrics-svc.metrics:8428"
  name       = "VictoriaMetrics"
  is_default = true
}

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

resource "grafana_data_source" "victorialogs" {
  type        = "victoriametrics-logs-datasource"
  name        = "VictoriaLogs"
  url         = "http://victorialogs-svc.logs:9428"
  access_mode = "proxy"
}

resource "grafana_data_source" "todoist-tasks" {
  type = "yesoreyeram-infinity-datasource"
  name = "todoist-tasks"
  url  = "https://api.todoist.com/rest/v2/tasks"
  json_data_encoded = jsonencode({
    auth_method = "bearerToken"
  })
  secure_json_data_encoded = jsonencode({
    bearerToken = var.todoist_token
  })
}

resource "grafana_data_source" "todoist-projects" {
  type = "yesoreyeram-infinity-datasource"
  name = "todoist-projects"
  url  = "https://api.todoist.com/rest/v2/projects"
  json_data_encoded = jsonencode({
    auth_method = "bearerToken"
  })
  secure_json_data_encoded = jsonencode({
    bearerToken = var.todoist_token
  })
}

resource "grafana_data_source" "clickhouse" {
  type = "grafana-clickhouse-datasource"
  name = "Clickhouse"
  json_data_encoded = jsonencode({
    default_database = "default"
    url              = "clickhouse-svc.clickhouse"
    port             = 9000
    protocol         = "native"
  })
  secure_json_data_encoded = jsonencode({
    password = var.clickhouse_password
  })
}

resource "grafana_data_source" "postgresql" {
  type = "postgres"
  name = "Postgres"
  url  = "postgres-svc.db:5432"
  secure_json_data_encoded = jsonencode({
    password = var.postgres_password
  })
  json_data_encoded = jsonencode({
    database = "personal"
    sslmode  = "disable"
    user     = "admin"
  })
}

resource "grafana_data_source" "twitch-api" {
  type = "yesoreyeram-infinity-datasource"
  name = "Twitch-API"
  url  = "https://api.twitch.tv/helix"
  json_data_encoded = jsonencode({
    auth_method  = "customHeader"
    allowedHosts = ["https://api.twitch.tv/helix"]
    custom_headers = {
      "Client-ID"     = var.twitch_client_id
      "Authorization" = "Bearer ${var.twitch_oauth_token}"
    }
  })
}
