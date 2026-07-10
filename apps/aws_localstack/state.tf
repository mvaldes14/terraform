terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "localstack"
    }
  }
}
