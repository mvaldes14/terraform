terraform {
  cloud {
    organization = "mvaldes"

    workspaces {
      name = "cloudflare"
    }
  }
}
