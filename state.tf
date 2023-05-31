terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "example-workspace"
    }
  }
}
