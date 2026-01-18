# GitHub Repository Module Examples

This directory contains examples demonstrating how to use the GitHub repository module.

## Basic Example

The `main.tf` file in this directory shows how to:

1. Create multiple repositories using the module with a `for_each` loop
2. Configure different settings per repository using local variables
3. Conditionally add secrets to specific repositories
4. Configure webhooks for all repositories
5. Output useful information about created repositories

## Running the Example

1. Ensure you have the GitHub provider configured with proper credentials
2. Set up your variables (you can create a `terraform.tfvars` file):

```hcl
dockerhub_token    = "your-token"
dockerhub_username = "your-username"
telegram_token     = "your-telegram-token"
telegram_to        = "your-telegram-chat-id"
gh_discord_url     = "your-discord-webhook-url"
```

3. Initialize and apply:

```bash
cd examples
terraform init
terraform plan
terraform apply
```

## Migration from Existing Configuration

If you're migrating from the existing `apps/github/main.tf` configuration:

1. The module handles the same resources but in a more reusable way
2. You can keep your existing `locals.tf` structure and adapt it to work with the module
3. The module provides additional features like branch protection and more flexible secret management

## Customization

You can customize the example by:

- Modifying the repository definitions in the `local.repositories` map
- Adjusting which repositories receive secrets
- Changing webhook configurations
- Adding branch protection rules
- Configuring additional repository settings

See the main module README for all available variables and options.
