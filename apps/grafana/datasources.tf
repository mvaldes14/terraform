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
}


resource "grafana_data_source" "elastic" {
  type               = "Elasticsearch"
  name               = "elastic"
  url                = "http://homelab-es-elastic.elastic"
  basic_auth_enabled = true
  secure_json_data_encoded = jsonencode({
    basicAuthUsername = "elastic"
    basicAuthPassword = var.elasticsearch_password
  })
  json_data_encoded = jsonencode({
    index = "logs-*"
  })

}
