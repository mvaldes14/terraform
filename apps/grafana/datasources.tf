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
