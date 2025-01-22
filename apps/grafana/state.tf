terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "grafana"
    }
  }
}
