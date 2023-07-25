terraform {
  cloud {
    organization = "elxilote"

    workspaces {
      name = "aws"
    }
  }
}
