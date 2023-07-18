terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "localstack"
    }
  }
}
