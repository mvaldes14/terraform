# Vault Secrets Module

Fetches secrets from HashiCorp Vault KV secrets engines (v1 and v2).

## Usage

```hcl
# KV v2 (default)
module "app_secrets" {
  source = "git::https://github.com/mvaldes14/terraform.git//modules/vault-secrets?ref=main"

  path = "secret/myapp"
}

# KV v1
module "legacy_secrets" {
  source = "git::https://github.com/mvaldes14/terraform.git//modules/vault-secrets?ref=main"

  path   = "kv/myapp"
  engine = "kv-v1"
}

# Access individual secret values
resource "some_resource" "example" {
  password = module.app_secrets.secrets["password"]
}
```

## Requirements

The Vault provider must be configured in the calling module/app:

```hcl
provider "vault" {
  address = "https://vault.example.com"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `path` | Full path to the secret in Vault | `string` | - | yes |
| `engine` | Secrets engine type (`kv-v1` or `kv-v2`) | `string` | `kv-v2` | no |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `secrets` | The secret data map retrieved from Vault | yes |
