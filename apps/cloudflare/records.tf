# ─── DNS records ────────────────────────────────────────────────────────────
# Every internal service is fronted by a single Cloudflare Tunnel, so each entry
# becomes a proxied CNAME -> <tunnel-id>.cfargotunnel.com. Add a new service by
# appending its name to local.services.
#
# The tunnel target is driven by var.cloudflare_tunnel_id.
#
# If a record already exists in Cloudflare, also register its record ID in
# local.existing_record_ids (imports.tf) so it is imported instead of recreated.
locals {
  # Internal services routed through the Cloudflare Tunnel.
  services = [
    "argo",
    "atlantis",
    "auth",
    "automate",
    "blog",
    "bots",
    "chi",
    "db",
    "doit",
    "draw",
    "gotify",
    "grafana",
    "paperless",
    "s3",
    "search",
    "signoz",
    "tkd",
    "umami",
    "vault",
  ]

  # Keyed by service name so for_each addresses stay stable regardless of list
  # order — this is what makes imports and in-place edits safe. Keys match
  # local.existing_record_ids (imports.tf).
  dns_records_map = {
    for name in local.services : name => {
      name    = name
      type    = "CNAME"
      content = "${var.cloudflare_tunnel_id}.cfargotunnel.com"
    }
  }
}

# Cloudflare DNS records for internal services, looped over via for_each.
# All are proxied CNAMEs pointing at the shared Cloudflare Tunnel.
resource "cloudflare_dns_record" "this" {
  for_each = local.dns_records_map

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  ttl     = 1
  proxied = true
  comment = "Cloudflare Tunnel - homelab"
}
