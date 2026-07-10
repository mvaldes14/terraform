# ─── Secret engines (mounts) ──────────────────────────────────────────────────
# Add a KV secrets engine by appending an entry to this map (key = mount path).
#   version     : "2" (kv-v2, default) or "1" (kv-v1)
#   description : optional free text
locals {
  kv_mounts = {
    "secret" = { version = "2", description = "General KV v2 store" }
    # "homelab" = { version = "2", description = "Homelab app secrets" }
  }
}

resource "vault_mount" "kv" {
  for_each = local.kv_mounts

  path        = each.key
  type        = "kv"
  options     = { version = try(each.value.version, "2") }
  description = try(each.value.description, null)
}
