terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "forgejo"
    }
  }
}
