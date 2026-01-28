data "vault_kv_secret_v2" "this" {
  count = var.engine == "kv-v2" ? 1 : 0
  mount = split("/", var.path)[0]
  name  = join("/", slice(split("/", var.path), 1, length(split("/", var.path))))
}

data "vault_generic_secret" "this" {
  count = var.engine == "kv-v1" ? 1 : 0
  path  = var.path
}

locals {
  secrets = var.engine == "kv-v2" ? data.vault_kv_secret_v2.this[0].data : data.vault_generic_secret.this[0].data
}
