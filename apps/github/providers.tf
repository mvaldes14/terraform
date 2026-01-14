terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.9.1"
    }
  }
}

provider "github" {
  owner = "mvaldes14"
}
