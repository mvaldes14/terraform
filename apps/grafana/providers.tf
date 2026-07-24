terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "4.41.0"
    }
  }
}

provider "grafana" {
  url  = "https://grafana.mvaldes.dev"
  auth = var.grafana_api_token
}
