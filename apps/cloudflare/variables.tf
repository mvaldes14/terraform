variable "cloudflare_zone_id" {
  type        = string
  description = "Default Cloudflare zone ID that DNS records are created in. Records may override this per-entry in local.dns_records."
}

variable "cloudflare_tunnel_id" {
  type        = string
  description = "Cloudflare Tunnel ID that all service CNAMEs point to (<tunnel-id>.cfargotunnel.com). Set as a sensitive var in the HCP workspace."
  sensitive   = true
}
