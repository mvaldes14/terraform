terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "gitea"
    }
  }
}
