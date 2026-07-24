# GitHub

Manages all `mvaldes14` GitHub repositories from a single loopable map, via the
[`github-repo`](../../modules/github-repo) module.

## Layout

| File           | Purpose                                                                 |
| -------------- | ---------------------------------------------------------------------- |
| `repos.tf`     | `repositories` map (add repos here) + `module.repositories` loop         |
| `data.tf`      | Data sources (e.g. the externally-managed `blog` repo)                  |
| `variables.tf` | Sensitive inputs: DockerHub creds, Gotify webhook URL                   |
| `providers.tf` | Provider `integrations/github` `6.9.1`, owner `mvaldes14`               |
| `state.tf`     | Terraform Cloud workspace `github`                                      |

## Auth

Provider reads `GITHUB_TOKEN` from the environment. Set it — along with the
`dockerhub_token`, `dockerhub_username`, and `gh_gotify_url` variables — as
sensitive values in the `github` Terraform Cloud workspace.

## Add a repository

Append an entry to `local.repositories` in `repos.tf`. The map key is the repo name:

```hcl
"my-new-repo" = {
  name                     = "my-new-repo"
  license                  = "MIT"
  topics                   = ["homelab"]
  visibility               = "public"   # or "private"
  enable_dockerhub_secrets = false      # true injects DockerHub Actions secrets
}
```

Each entry drives one `github-repo` module instance. A Gotify webhook (all
events) is attached to every repo via `var.gh_gotify_url`.

### Options

| Key                        | Effect                                                              |
| -------------------------- | ------------------------------------------------------------------ |
| `visibility`               | `public` or `private` (validated in the module)                    |
| `topics`                   | List of repo topics                                                |
| `license`                  | License template (`MIT`, `apache-2.0`, …)                          |
| `enable_dockerhub_secrets` | When `true`, sets `DOCKERHUB_TOKEN` / `DOCKERHUB_USERNAME` secrets |
| `archived`                 | Present on archived repos (see `linear.nvim`, `todoist.nvim`)      |

## Import an existing repository

```bash
terraform import 'module.repositories["repo-name"].github_repository.repo' repo-name
```

Then add the matching entry to `local.repositories` so config and state agree.

## Note on structure

This is one Terraform Cloud workspace, so all `*.tf` files load into a single
state. Separate concerns by **file** (`repos.tf`, `actions.tf`, …), not by
subfolder — Terraform does not recurse into subdirectories, and repo-scoped
resources (secrets, webhooks) belong in the same state as the repos they attach to.
