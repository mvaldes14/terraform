resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  url  = "http://prometheus.local.net"
  name = "Prometheus"
}

resource "grafana_"
