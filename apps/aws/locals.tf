locals {
  # Applied to every resource via the provider's default_tags block.
  common_tags = {
    ManagedBy   = "terraform"
    Environment = var.environment
    Repo        = "mvaldes14/terraform"
  }
}
