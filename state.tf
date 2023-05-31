terraform {
  backend "s3" {
    bucket                      = "terraform"
    key                         = "terraform.tfstate"
    region                      = "main"
    endpoint                    = "https://s3.mvaldes.dev"
    force_path_style            = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
  }
}

