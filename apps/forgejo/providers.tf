terraform {
  required_providers {
    forgejo = {
      source  = "svalabs/forgejo"
      version = "1.7.0"
    }
  }
}

provider "forgejo" {
  host = var.forgejo_base_uri
}
