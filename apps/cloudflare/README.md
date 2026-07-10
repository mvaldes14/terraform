# Cloudflare DNS

Manages Cloudflare DNS records for internal services using a single, loopable list.

## Layout

| File          | Purpose                                                        |
| ------------- | ------------------------------------------------------------- |
| `records.tf`  | `dns_records` list (append here) + map + `cloudflare_dns_record.this` loop |
| `imports.tf`  | `existing_record_ids` map + `for_each` import block            |
| `variables.tf`| `cloudflare_zone_id`                                           |
| `providers.tf`| Provider `cloudflare/cloudflare` `5.22.0`                      |
| `state.tf`    | Terraform Cloud workspace `cloudflare`                         |

## Auth

Provider reads `CLOUDFLARE_API_TOKEN` from the environment. Set it as a sensitive
environment variable in the `cloudflare` Terraform Cloud workspace, and set the
`cloudflare_zone_id` Terraform variable.

## Add a new record

Append to `local.dns_records` in `records.tf`:

```hcl
{ name = "vault", type = "A", content = "192.168.1.20", comment = "Vault" },
```

Optional keys: `ttl` (default `1` = auto), `proxied` (default `false`),
`priority` (MX/SRV/URI), `zone_id` (per-record override).

## Import an existing record

1. Add the record to `local.dns_records` as above.
2. Get its Cloudflare record ID (`./scripts/list-records.sh <zone_id>`).
3. Add it to `local.existing_record_ids` in `imports.tf`, keyed `"<name>-<type>"`:

   ```hcl
   "vault-A" = "372e67954025e0ba6aab9def8b8f5a3b"
   ```

4. Plan/apply — Terraform imports it (ID format `<zone_id>/<record_id>`) and
   reconciles it to config instead of recreating it.
