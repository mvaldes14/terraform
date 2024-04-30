resource "grafana_data_source" "prometheus" {
  type       = "prometheus"
  url        = "http://prometheus.local.net"
  name       = "Prometheus"
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


resource "grafana_data_source" "elastic-logs" {
  type               = "elasticsearch"
  name               = "elastic-logs"
  url                = "https://homelab-es-elastic.elastic:9200"
  basic_auth_enabled = true
  secure_json_data_encoded = jsonencode({
    basicAuthUsername = "elastic"
    basicAuthPassword = var.elasticsearch_password
  })
  json_data_encoded = jsonencode({
    index         = "logs-*"
    tlsSkipVerify = true
    interval      = "hourly"
  })
}

resource "grafana_data_source" "elastic-twitch" {
  type               = "elasticsearch"
  name               = "elastic-twitch"
  url                = "https://homelab-es-elastic.elastic:9200"
  basic_auth_enabled = true
  secure_json_data_encoded = jsonencode({
    basicAuthUsername = "elastic"
    basicAuthPassword = var.elasticsearch_password
  })
  json_data_encoded = jsonencode({
    index         = "twitch"
    tlsSkipVerify = true
    interval      = "hourly"
  })
}
