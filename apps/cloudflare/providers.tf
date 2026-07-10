terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.22.0"
    }
  }
}

provider "cloudflare" {
  # Auth via the CLOUDFLARE_API_TOKEN environment variable.
  # Set it as a sensitive environment variable in the Terraform Cloud workspace.
}
