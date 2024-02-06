resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  url  = "http://prometheus.local.net"
  name = "Prometheus"
}


resource "grafana_data_source" "github" {
  type = "grafana-github-datasource"
  name = "Github"
  json_data_encoded = jsonencode({
    owner = ""
  })
}
