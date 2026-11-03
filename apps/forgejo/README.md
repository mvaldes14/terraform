# Forgejo

Manages GitHub-to-Forgejo pull mirrors. GitHub remains the source of truth;
Forgejo provides a read-only replica refreshed automatically by Forgejo.

## Layout

| File | Purpose |
| --- | --- |
| `repos.tf` | Repository catalog and pull-mirror resources |
| `variables.tf` | Forgejo endpoint |
| `providers.tf` | Provider `svalabs/forgejo` `1.7.0` |
| `state.tf` | Terraform Cloud workspace `forgejo` |

## Auth

Set `FORGEJO_API_TOKEN` as a sensitive environment variable in Terraform Cloud
workspace `forgejo`. Managing user-owned repositories requires a Forgejo admin
token.

No GitHub token is required for public repositories. Private repositories will
need a separate GitHub read token passed as the repository `auth_token`; none are
included in the initial pilot.

## Pilot repositories

Initial pilot deliberately uses public repositories without meaningful CI load:

- `dotfiles-nix`
- `dotfiles-vorpal`

Forgejo Actions are disabled for these repositories. Each repository is created
as a pull mirror of `https://github.com/mvaldes14/<repo>.git`, refreshes every
eight hours, and prunes refs removed from GitHub.

## Migration sequence

Do not delete an existing Forgejo pull mirror until its GitHub source and any
Forgejo-only packages, releases, issues, or settings have been checked.

For each pilot repository:

1. Confirm GitHub contains all required branches and tags.
2. Delete the existing Forgejo pull mirror through the UI.
3. Apply Terraform to create a managed pull mirror from GitHub.
4. Verify default branch, branches, tags, visibility, and mirror status.
5. Run a second Terraform plan and confirm it is empty.

## Safety

- Repositories use `prevent_destroy = true` after Terraform creates them.
- GitHub remains the source of truth.
- GitHub repositories remain managed by `apps/github`.
- No GitHub credential is stored in Terraform state for public mirrors.
