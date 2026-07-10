# Terraform Manifests

Modules and manifests used to manage my homelab and cloud infrastructure.

## Structure

- **`apps/`** — deployable, per-provider configurations. Each app is one Terraform
  Cloud workspace with its own state. Files are named by content
  (`records.tf`, `repos.tf`, …); repeated resources use a `locals` map + `for_each`.
- **`modules/`** — reusable, environment-agnostic components consumed by apps.

## Apps

| App               | Provider(s)          | Manages                                   |
| ----------------- | -------------------- | ----------------------------------------- |
| `github`          | integrations/github  | Repositories, webhooks, Actions secrets   |
| `cloudflare`      | cloudflare/cloudflare| DNS records for internal services         |
| `aws`             | hashicorp/aws        | KMS, S3, general AWS resources            |
| `aws_localstack`  | hashicorp/aws        | LocalStack (VPC, EC2, S3) emulation       |
| `vault`           | hashicorp/vault      | Mounts, ACL policies, auth backends       |
| `signoz`          | SigNoz/signoz        | Dashboards & alerts (stub)                |
| `grafana`         | grafana/grafana      | Folders, contact points, notif. policies  |
| `containers`      | kreuzwerker/docker   | Local Docker containers                   |
| `demo`            | —                    | Scratch / testing                         |

Each app has its own `README.md` with usage, auth, and import notes.

## Modules

| Module           | Purpose                                     |
| ---------------- | ------------------------------------------- |
| `github-repo`    | Full-featured GitHub repository management  |
| `vault-secrets`  | Read secrets from Vault KV (v1/v2)          |
| `containers`     | Docker image + container                    |
| `localstack/vpc` | VPC for LocalStack                          |

## State & workflow

- **State** is managed in HashiCorp Terraform Cloud — one workspace per app
  (orgs: `mvaldes` for homelab, `elxilote` for AWS).
- **CI/CD** is [Atlantis](./atlantis.yaml): plan on PR, apply + automerge on approval.
- **Provider auth** is via environment variables set as sensitive workspace vars
  (e.g. `GITHUB_TOKEN`, `CLOUDFLARE_API_TOKEN`, `VAULT_TOKEN`, `SIGNOZ_ACCESS_TOKEN`).

## Development

```bash
cd apps/<app>
terraform init
terraform plan
```

See [`CLAUDE.md`](./CLAUDE.md) for conventions and detailed structure.
