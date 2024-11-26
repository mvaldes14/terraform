terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "2.1.0"
    }
  }
}

provider "grafana" {
  url  = "https://grafana.mvaldes.dev"
  auth = var.GRAFANA_API_TOKEN
}
