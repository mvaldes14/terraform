terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "main"
    }
  }
}
