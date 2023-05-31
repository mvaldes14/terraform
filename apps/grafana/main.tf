terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "1.40.1"
    }
  }
}

variable "grafana_api_token" {
    type = string
  }
