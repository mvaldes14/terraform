terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.10.1"
    }
  }
}

provider "vault" {
  address = var.vault_address
  # Auth via the VAULT_TOKEN environment variable.
  # Set it as a sensitive environment variable in the Terraform Cloud workspace.
}
