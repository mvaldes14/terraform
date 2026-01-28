variable "path" {
  description = "The full path to the secret in Vault (e.g. 'secret/data/myapp')"
  type        = string
}

variable "engine" {
  description = "The secrets engine type to use"
  type        = string
  default     = "kv-v2"

  validation {
    condition     = contains(["kv-v1", "kv-v2"], var.engine)
    error_message = "Engine must be either 'kv-v1' or 'kv-v2'"
  }
}
