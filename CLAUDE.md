# CLAUDE.md

Guidance for working in this Terraform repo (homelab + cloud infra).

## Layout

- **`apps/`** — deployable configs. Each app = **one Terraform Cloud workspace**
  with its own state and provider config.
- **`modules/`** — reusable, environment-agnostic components consumed by apps.

## Conventions

1. **Name files by content.** No generic `main.tf` — use `records.tf`, `repos.tf`,
   `kms.tf`, `s3.tf`, `mounts.tf`, etc. Standard files: `state.tf`, `providers.tf`,
   `variables.tf`, `outputs.tf`. A `locals.tf` only exists for cross-cutting data
   (e.g. AWS `common_tags`); single-resource data lives in that resource's file.
2. **One workspace per app.** Terraform doesn't recurse into subdirectories, so a
   subfolder would be a *separate* workspace. Organize by file, not folder. Only
   split into a new app dir when a resource group needs an independent blast radius.
3. **Loop for repeated resources.** For many of the same type (repos, DNS records,
   buckets), define a `locals` map/list and `for_each` over it. Key maps by a
   stable identifier (e.g. `"<name>-<type>"`) so imports and edits stay safe.
4. **Homogeneous apps** (`github`, `cloudflare`) loop over one resource type.
   **Heterogeneous apps** (`aws`) use one file per service.
5. Every app has a `README.md` (usage, auth, import notes) and an entry in
   `atlantis.yaml`.

## State, auth, CI/CD

- **State**: Terraform Cloud, one workspace per app. Orgs: `mvaldes` (homelab),
  `elxilote` (AWS). Set the workspace in `state.tf` via a `cloud {}` block.
- **Provider auth**: environment variables set as **sensitive workspace vars** —
  `GITHUB_TOKEN`, `CLOUDFLARE_API_TOKEN`, `VAULT_TOKEN`, `SIGNOZ_ACCESS_TOKEN`, etc.
  Non-secret config (endpoints, zone IDs) goes through `variables.tf`.
- **CI/CD**: [Atlantis](./atlantis.yaml) — plan on PR, apply + automerge on approval.
  Add every new app as a project there (`when_modified: ["*.tf"]`).

## Adding a new app

```bash
mkdir apps/<name>
# create: state.tf (cloud block), providers.tf (pinned version), variables.tf,
#         <resource>.tf, README.md
```
Then create the TFC workspace + its sensitive env vars, and register the app in
`atlantis.yaml`. Pin provider versions to an exact release.

## Importing existing resources

Most infra already exists — **import, don't recreate**. Make config match reality
first, then import. Patterns:
- `cloudflare` — `for_each` import block driven by `local.existing_record_ids`
  (ID format `<zone_id>/<record_id>`); see `apps/cloudflare/imports.tf`.
- `vault` / `signoz` / others — `terraform import '<addr>' <id>` (see app READMEs).

## Modules

| Module           | Purpose                                    |
| ---------------- | ------------------------------------------ |
| `github-repo`    | GitHub repo management (used by `github`)  |
| `vault-secrets`  | Read secrets from Vault KV (v1/v2)         |
| `containers`     | Docker image + container                   |
| `localstack/vpc` | VPC for LocalStack                         |

Apps reference modules via git source (`git::https://github.com/mvaldes14/terraform.git//modules/<name>?ref=main`)
so Atlantis/TFC can resolve them.

## Workflow

Commit style: conventional commits. Never `git commit`/`push` without explicit
confirmation. Run `terraform fmt` before committing.
