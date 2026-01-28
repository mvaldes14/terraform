output "secrets" {
  description = "The secret data retrieved from Vault"
  value       = local.secrets
  sensitive   = true
}
