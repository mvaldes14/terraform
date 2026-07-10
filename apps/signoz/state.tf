terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "signoz"
    }
  }
}
