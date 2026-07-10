# AWS

General-purpose AWS resources. Unlike `github`/`cloudflare` (many of one resource
type), this app is heterogeneous — organize by **one file per service**.

## Layout

| File           | Purpose                                                        |
| -------------- | ------------------------------------------------------------- |
| `providers.tf` | `hashicorp/aws` `5.8.0`, assume-role auth, `region`, `default_tags` |
| `state.tf`     | Terraform Cloud workspace `aws` (org `elxilote`)              |
| `variables.tf` | `region`, `environment`                                       |
| `locals.tf`    | `common_tags` (applied to everything via `default_tags`)     |
| `outputs.tf`   | Aggregated outputs                                            |
| `kms.tf`       | KMS keys                                                      |
| `s3.tf`        | S3 buckets (loop pattern)                                     |

## Auth

Provider assumes `arn:aws:iam::375195053376:role/terraform-assume-role`. Base
credentials come from the environment (or the Terraform Cloud workspace).

## Conventions

- **One file per service.** New service → new file (`sqs.tf`, `ecr.tf`, …).
- **Tag automatically.** `default_tags` applies `local.common_tags` to every
  resource — no per-resource `tags` needed for the common set.
- **Loop for repeated resources.** When you have many of the same type, define a
  map local at the top of that service file and `for_each` it — see `s3.tf`.
- **Split workspaces only for blast radius.** Keep one `aws` workspace until a
  resource group genuinely needs an independent apply cadence.

## Add an S3 bucket

Append to `local.s3_buckets` in `s3.tf` (key = globally-unique bucket name):

```hcl
"mvaldes-backups" = { versioning = true }
```

Every bucket gets a public-access block by default; `versioning` is opt-in.
