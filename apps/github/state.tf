terraform {
  cloud {
    organization = "mvaldes14"

    workspaces {
      name = "github"
    }
  }
}
