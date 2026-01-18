variable "repository_name" {
  description = "The name of the repository"
  type        = string
}

variable "visibility" {
  description = "The visibility of the repository (public or private)"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "Visibility must be either 'public' or 'private'"
  }
}

variable "topics" {
  description = "A list of topics for the repository"
  type        = list(string)
  default     = []
}

variable "license_template" {
  description = "The license template to use (e.g., MIT, apache-2.0, gpl-3.0)"
  type        = string
  default     = "MIT"
}

variable "actions_secrets" {
  description = "GitHub Actions secrets to create for the repository"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "webhook_url" {
  description = "The URL for the webhook (leave empty to skip webhook creation)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "webhook_events" {
  description = "The events to trigger the webhook"
  type        = list(string)
  default     = ["*"]
}
