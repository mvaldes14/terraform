terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "grafana"
    }
  }
}
