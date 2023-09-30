terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "github"
    }
  }
}
