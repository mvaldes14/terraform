# Migration Guide: Moving to Module-Based Structure

This guide explains how to migrate your existing GitHub repository resources to the new module-based structure without destroying and recreating resources.

## Why Use Moved Blocks?

When refactoring Terraform code, you want to change the structure without destroying existing infrastructure. The `moved` block tells Terraform that a resource has been reorganized in your configuration, but the actual infrastructure hasn't changed.

**Without `moved` blocks:**
- Terraform sees the old resource address as "deleted"
- Terraform sees the new module resource as "new"
- Result: Your repositories would be destroyed and recreated ❌

**With `moved` blocks:**
- Terraform understands the resource has moved
- No destroy/create cycle happens
- Result: Clean refactor with no downtime ✅

## Migration Steps

### Step 1: Backup Your State

Always backup your state before making structural changes:

```bash
cd apps/github
terraform state pull > backup-state-$(date +%Y%m%d).json
```

### Step 2: Review Current Resources

Check what resources currently exist:

```bash
terraform state list
```

You should see something like:
```
github_repository.repo["meal-notifier"]
github_repository.repo["k8s-apps"]
github_repository_webhook.wh["meal-notifier"]
github_actions_secret.dockerhub_token["meal-notifier"]
...
```

### Step 3: Update Your Configuration

Replace your existing inline resources with the module. In your `apps/github/main.tf`:

**Before:**
```hcl
resource "github_repository" "repo" {
  for_each   = local.repositories
  name       = each.key
  visibility = each.value.visibility
  # ...
}

resource "github_repository_webhook" "wh" {
  for_each   = local.repositories
  repository = each.key
  # ...
}
```

**After:**
```hcl
module "repositories" {
  for_each = local.repositories
  source   = "../../modules/github-repo"

  repository_name = each.key
  visibility      = each.value.visibility
  topics          = each.value.topics
  license_template = each.value.license

  webhook_url = var.gh_discord_url
  webhook_events = ["*"]

  actions_secrets = contains(local.repo_with_secrets, each.key) ? {
    DOCKERHUB_TOKEN    = var.dockerhub_token
    DOCKERHUB_USERNAME = var.dockerhub_username
    TELEGRAM_TOKEN     = var.telegram_token
    TELEGRAM_TO        = var.telegram_to
  } : {}
}
```

### Step 4: Add Moved Blocks

Add `moved` blocks to map old resource addresses to new ones. You can either:

**Option A: Add to main.tf**

Add the moved blocks directly to your `apps/github/main.tf`:

```hcl
# Repositories
moved {
  from = github_repository.repo["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_repository.repo
}

moved {
  from = github_repository.repo["k8s-apps"]
  to   = module.repositories["k8s-apps"].github_repository.repo
}

# Webhooks
moved {
  from = github_repository_webhook.wh["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_repository_webhook.webhook[0]
}

# Secrets (note the key name changes)
moved {
  from = github_actions_secret.dockerhub_token["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}

moved {
  from = github_actions_secret.dockerhub_username["meal-notifier"]
  to   = module.repositories["meal-notifier"].github_actions_secret.secrets["DOCKERHUB_USERNAME"]
}

# Repeat for all repositories and secrets...
```

**Option B: Create separate moved.tf file**

Create `apps/github/moved.tf` with all your moved blocks for better organization.

### Step 5: Plan and Verify

Run `terraform plan` to verify no resources will be destroyed:

```bash
terraform plan
```

Look for output like:
```
Plan: 0 to add, 0 to change, 0 to destroy.

Terraform has detected that you have moved resources. The following
resource instances have moved to a new address:
  - github_repository.repo["meal-notifier"] has moved to
    module.repositories["meal-notifier"].github_repository.repo
```

**⚠️ IMPORTANT:** If you see resources being destroyed and recreated, STOP and review your moved blocks!

### Step 6: Apply the Migration

Once the plan looks good:

```bash
terraform apply
```

This will update the state file to reflect the new structure without touching actual infrastructure.

### Step 7: Clean Up

After successful migration, you can remove the `moved` blocks. They're only needed for the migration itself.

```bash
# Optionally remove moved blocks after successful apply
# They don't hurt anything if left in place though
```

## Common Migration Patterns

### Pattern 1: Simple Repository Move

```hcl
moved {
  from = github_repository.repo["repo-name"]
  to   = module.repositories["repo-name"].github_repository.repo
}
```

### Pattern 2: Webhook Move

Note the `[0]` at the end because the webhook uses `count`:

```hcl
moved {
  from = github_repository_webhook.wh["repo-name"]
  to   = module.repositories["repo-name"].github_repository_webhook.webhook[0]
}
```

### Pattern 3: Secret Move with Key Name

The old structure had separate resources per secret. The new structure uses a map with secret names as keys:

```hcl
# Old: github_actions_secret.dockerhub_token["repo-name"]
# New: module.repositories["repo-name"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]

moved {
  from = github_actions_secret.dockerhub_token["repo-name"]
  to   = module.repositories["repo-name"].github_actions_secret.secrets["DOCKERHUB_TOKEN"]
}
```

## Troubleshooting

### "Error: Moved object still exists"

This means the old resource still exists in your configuration. Make sure you've replaced all old `resource` blocks with the module.

### "No matching resource instance"

The `from` address doesn't exist in your state. Check the exact address with:

```bash
terraform state list | grep <resource-name>
```

### Resources Being Recreated

If `terraform plan` shows resources being destroyed and recreated:

1. Check your `moved` block addresses are correct
2. Verify the resource actually exists in state with `terraform state list`
3. Make sure the `to` address matches the new module structure exactly

### Secret Migration Issues

If secrets are being recreated:

1. Ensure secret names in the map match exactly (case-sensitive)
2. Old structure: `github_actions_secret.dockerhub_token["repo"]`
3. New structure: `github_actions_secret.secrets["DOCKERHUB_TOKEN"]`
4. Note the key is now `"DOCKERHUB_TOKEN"` not the resource name

## Complete Migration Example

See `migration.tf` in this directory for a complete example with all repositories from the existing `apps/github` configuration.

## Benefits After Migration

Once migrated, you get:

✅ **Reusability** - Use the module for new repositories
✅ **Consistency** - All repos configured the same way
✅ **Maintainability** - Update module once, affects all repos
✅ **Clarity** - Clear separation between config and implementation
✅ **Flexibility** - Easy to add new features to all repos
✅ **Documentation** - Module is self-documenting with variables

## Reference

- [Terraform Moved Block Documentation](https://www.terraform.io/language/modules/develop/refactoring)
- [Refactoring Terraform Code](https://developer.hashicorp.com/terraform/tutorials/configuration-language/move-config)
