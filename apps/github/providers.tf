terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.44.0"
    }
  }
}

provider "github" {}
