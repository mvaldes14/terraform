terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "aws"
    }
  }
}
