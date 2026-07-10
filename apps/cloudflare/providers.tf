terraform {
  # import blocks with for_each and an expression `id` require Terraform >= 1.7.
  required_version = ">= 1.7"

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
