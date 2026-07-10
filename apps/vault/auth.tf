# ─── Auth backends ────────────────────────────────────────────────────────────
# Enable an auth method by appending an entry to this map (key = mount path).
#   type : userpass | approle | github | kubernetes | ...
locals {
  auth_backends = {
    # "userpass" = { type = "userpass", description = "Static user logins" }
    # "approle"  = { type = "approle", description = "Machine / CI auth" }
  }
}

resource "vault_auth_backend" "this" {
  for_each = local.auth_backends

  type        = each.value.type
  path        = each.key
  description = try(each.value.description, null)
}
