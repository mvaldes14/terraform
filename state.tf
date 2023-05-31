terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "default"
    }
  }
}
