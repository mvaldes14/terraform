terraform {
  required_providers {
    signoz = {
      source  = "SigNoz/signoz"
      version = "0.1.5"
    }
  }
}

provider "signoz" {
  endpoint = var.signoz_endpoint
}
