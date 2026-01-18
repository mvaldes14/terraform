# Migration Instructions for GitHub Repository Module

This directory contains everything needed to migrate from inline resources to the module-based structure.

## Files

- `main.tf` - Current inline resource definitions (OLD)
- `main-with-module.tf` - New module-based configuration with moved blocks (NEW)
- `locals.tf` - Repository definitions (unchanged)
- `variables.tf` - Variable definitions (unchanged)
- `providers.tf` - Provider configuration (unchanged)
- `state.tf` - State backend configuration (unchanged)
- `data.tf` - Data sources (unchanged)

## Migration Process

### Step 1: Backup Your State

```bash
cd apps/github
terraform state pull > backup-state-$(date +%Y%m%d-%H%M%S).json
```

### Step 2: Rename Files

```bash
# Backup the old main.tf
mv main.tf main.tf.old

# Use the new module-based configuration
mv main-with-module.tf main.tf
```

### Step 3: Initialize the Module

```bash
terraform init
```

Terraform will download the module from the local path.

### Step 4: Preview Changes

```bash
terraform plan
```

**Expected output:**
```
Plan: 0 to add, 0 to change, 0 to destroy.

Terraform has detected that you have moved resources...
```

**⚠️ CRITICAL:** If you see ANY resources being destroyed or recreated, STOP and review!
The plan should show 0 changes with only moved resources noted.

### Step 5: Apply Migration

Once verified the plan shows no changes:

```bash
terraform apply
```

This updates the state file without touching actual infrastructure.

### Step 6: Verify State

Check that resources are now in the module:

```bash
terraform state list
```

You should see:
```
module.repositories["meal-notifier"].github_repository.repo
module.repositories["meal-notifier"].github_repository_webhook.webhook[0]
module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
...
```

### Step 7: Clean Up (Optional)

After successful migration:

```bash
# Remove the old file
rm main.tf.old

# Optionally remove moved blocks from main.tf
# They don't hurt anything if left in place
```

## What the Moved Blocks Do

The `moved` blocks in `main-with-module.tf` tell Terraform:

```hcl
moved {
  from = github_repository.repo["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_repository.repo
}
```

This means:
- **from**: The old resource address in your state
- **to**: The new resource address in the module

Terraform updates the state file to use the new addresses without recreating resources.

## Key Changes in Module Usage

### Repositories
```hcl
# OLD
resource "github_repository" "repo" {
  for_each = local.repositories
  name     = each.key
  # ...
}

# NEW
module "repositories" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name = each.key
  # ...
}
```

### Webhooks
```hcl
# OLD - webhook is separate resource
resource "github_repository_webhook" "wh" {
  for_each = local.repositories
  # ...
}

# NEW - webhook is inside module
# Configured via module variables:
module "repositories" {
  webhook_url = var.gh_discord_url
  webhook_events = ["*"]
}
```

### Secrets
```hcl
# OLD - multiple separate resources
resource "github_actions_secret" "dockerhub_token" {
  for_each = local.repo_with_secrets
  # ...
}

resource "github_actions_secret" "dockerhub_username" {
  for_each = local.repo_with_secrets
  # ...
}

# NEW - single resource with map
module "repositories" {
  actions_secrets = {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    TELEGRAM_TOKEN     = var.telegram_token
    TELEGRAM_TO        = var.telegram_to
  }
}
```

## Rollback Plan

If something goes wrong:

```bash
# Restore old configuration
mv main.tf main-with-module.tf
mv main.tf.old main.tf

# Restore state from backup
terraform state push backup-state-YYYYMMDD-HHMMSS.json

# Verify
terraform plan
```

## Troubleshooting

### "Error: Moved object still exists"

You have both the old `resource` blocks and the `module` blocks in your configuration.
Make sure you renamed/removed the old `main.tf`.

### "Resource not found in state"

The `from` address in a moved block doesn't match what's in your state.

Check actual state:
```bash
terraform state list | grep github_repository.repo
```

### Resources Being Recreated

Double-check:
1. All moved blocks are present for ALL resources
2. The `to` addresses match the module structure exactly
3. Secret keys in moved blocks match the map keys (e.g., `"DOCKERHUB_TOKEN"`)

## Benefits After Migration

✅ **Reusable** - Easy to add new repositories
✅ **Consistent** - All repos configured identically
✅ **Maintainable** - Update module, all repos benefit
✅ **Clean** - Fewer lines of code in main.tf
✅ **Documented** - Module variables are self-documenting

## Adding New Repositories

After migration, adding a new repo is simple:

```hcl
# In locals.tf
locals {
  repositories = {
    # ... existing repos ...
    "new-repo" = {
      name       = "new-repo"
      license    = "MIT"
      topics     = ["automation"]
      visibility = "public"
    }
  }
}
```

No need for moved blocks - only required for existing resources!

## Questions?

Refer to:
- Module documentation: `../../modules/github-repo/README.md`
- Migration examples: `../../modules/github-repo/examples/MIGRATION.md`
- Terraform moved blocks: https://www.terraform.io/language/modules/develop/refactoring
