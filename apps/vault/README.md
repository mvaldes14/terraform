# Vault

Codifies the HashiCorp Vault server config (mounts, policies, auth) so the setup
is reproducible. This is the *configurator* — the [`vault-secrets`](../../modules/vault-secrets)
module is the *reader* other apps use to pull secrets back out.

## Layout

| File           | Purpose                                                        |
| -------------- | ------------------------------------------------------------- |
| `providers.tf` | `hashicorp/vault` `5.10.1`, address, token auth via env        |
| `state.tf`     | Terraform Cloud workspace `vault` (org `mvaldes`)             |
| `variables.tf` | `vault_address`                                              |
| `mounts.tf`    | KV secret engines (loop over `local.kv_mounts`)              |
| `policies.tf`  | ACL policies — auto-discovered from `policies/*.hcl`          |
| `auth.tf`      | Auth backends (loop over `local.auth_backends`)              |

## Auth

Provider reads `VAULT_TOKEN` from the environment. Set it as a sensitive
environment variable in the `vault` Terraform Cloud workspace; set the address
via `var.vault_address` (default `https://vault.mvaldes.dev`).

## Add things

- **Secret engine** → append to `local.kv_mounts` in `mounts.tf`.
- **Policy** → drop `policies/<name>.hcl`; it's picked up automatically.
- **Auth method** → append to `local.auth_backends` in `auth.tf`.

## Import existing config

Your Vault is already set up, so import rather than recreate. IDs are just the paths:

```bash
terraform import 'vault_mount.kv["secret"]'          secret
terraform import 'vault_policy.this["readonly"]'     readonly
terraform import 'vault_auth_backend.this["userpass"]' userpass
```

Make the config (map entry / `.hcl` file) match what exists first, then import so
plan shows no changes.
