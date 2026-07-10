# ─── ACL policies ─────────────────────────────────────────────────────────────
# Drop a "<name>.hcl" file in policies/ — it is picked up automatically and
# created as a Vault policy named "<name>". No map to maintain.
resource "vault_policy" "this" {
  for_each = fileset("${path.module}/policies", "*.hcl")

  name   = trimsuffix(each.value, ".hcl")
  policy = file("${path.module}/policies/${each.value}")
}
