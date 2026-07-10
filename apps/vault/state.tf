terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "vault"
    }
  }
}
