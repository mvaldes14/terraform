resource "grafana_data_source" "elasticsearch" {
  type          = "elasticsearch"
  url           = "http://elastic.server.local.net"
  name          = "Elasticsearch"
  database_name = "filebeat-*"
  json_data_encoded {
    es_version = "7.10.0"
    time_field = "@timestamp"
  }
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  url  = "http://prometheus.local.net"
  name = "Prometheus"
}

resource "grafana_data_source" "redis" {
  name = "redis"
  type = "redis-datasource"
  url  = "redis://192.168.1.22:6379"
}
