terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "github"
    }
  }
}
