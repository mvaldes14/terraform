terraform {
  required_providers {
    signoz = {
      source  = "SigNoz/signoz"
      version = "0.0.15"
    }
  }
}

provider "signoz" {
  endpoint = var.signoz_endpoint
  # Auth via the SIGNOZ_ACCESS_TOKEN environment variable.
  # Set it as a sensitive environment variable in the Terraform Cloud workspace.
}
