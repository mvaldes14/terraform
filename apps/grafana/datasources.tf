resource "grafana_data_source" "elasticsearch" {
  type                = "elasticsearch"
  url                 = "http://elastic.server.local.net"
  name                = "Elasticsearch"
  database_name       = "docker-logs"
  basic_auth_enabled  = true
  basic_auth_username = "elastic"
  json_data_encoded = jsonencode({
    es_version = "8.8.1"
    time_field = "@timestamp"
  })
  secure_json_data_encoded = jsonencode({
    basic_auth_password = var.elasticsearch_password
  })
}

resource "grafana_data_source" "prometheus" {
  type = "prometheus"
  url  = "http://prometheus.local.net"
  name = "Prometheus"
}

resource "grafana_data_source" "redis" {
  name = "redis"
  type = "redis-datasource"
  url  = "redis://redis.local.net:6379"
}
