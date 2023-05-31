# resource "grafana_data_source" "loki" {
#   type = "loki"
#   url  = "http://loki.local.net"
#   name = "Loki"
# }

resource "grafana_data_source" "elasticsearch" {
  type          = "elasticsearch"
  url           = "http://elastic.server.local.net"
  name          = "Elasticsearch"
  database_name = "filebeat-*"
  json_data {
    es_version = "7.10.0"
    time_field = "@timestamp"
  }
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  url  = "http://prometheus.local.net"
  name = "Prometheus"
}
