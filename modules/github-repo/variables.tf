variable "repository_name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "The visibility of the repository (public, private, or internal)"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be one of: public, private, internal"
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

variable "enable_vulnerability_alerts" {
  description = "Enable vulnerability alerts for the repository"
  type        = bool
  default     = true
}

variable "enable_issues" {
  description = "Enable issues for the repository"
  type        = bool
  default     = true
}

variable "enable_discussions" {
  description = "Enable discussions for the repository"
  type        = bool
  default     = false
}

variable "enable_projects" {
  description = "Enable projects for the repository"
  type        = bool
  default     = false
}

variable "enable_wiki" {
  description = "Enable wiki for the repository"
  type        = bool
  default     = false
}

variable "auto_init" {
  description = "Initialize the repository with a README.md"
  type        = bool
  default     = false
}

variable "gitignore_template" {
  description = "The gitignore template to use (e.g., Python, Node, Go)"
  type        = string
  default     = ""
}

variable "homepage_url" {
  description = "The homepage URL for the repository"
  type        = string
  default     = ""
}

variable "archived" {
  description = "Whether the repository is archived"
  type        = bool
  default     = false
}

variable "archive_on_destroy" {
  description = "Archive the repository instead of deleting it on destroy"
  type        = bool
  default     = true
}

variable "template_repository" {
  description = "Template repository to use for creating this repository"
  type = object({
    owner                = string
    repository           = string
    include_all_branches = optional(bool, false)
  })
  default = null
}

variable "actions_secrets" {
  description = "GitHub Actions secrets to create for the repository"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "webhook_url" {
  description = "The URL for the webhook"
  type        = string
  default     = ""
  sensitive   = true
}

variable "webhook_active" {
  description = "Whether the webhook is active"
  type        = bool
  default     = true
}

variable "webhook_content_type" {
  description = "The content type for the webhook (form or json)"
  type        = string
  default     = "json"

  validation {
    condition     = contains(["form", "json"], var.webhook_content_type)
    error_message = "Webhook content type must be either 'form' or 'json'"
  }
}

variable "webhook_insecure_ssl" {
  description = "Whether to allow insecure SSL for the webhook"
  type        = bool
  default     = false
}

variable "webhook_secret" {
  description = "The secret for the webhook"
  type        = string
  default     = ""
  sensitive   = true
}

variable "webhook_events" {
  description = "The events to trigger the webhook"
  type        = list(string)
  default     = ["push"]
}

variable "enable_branch_protection" {
  description = "Enable branch protection for the default branch"
  type        = bool
  default     = false
}

variable "branch_protection_pattern" {
  description = "The branch pattern to protect (e.g., main, master)"
  type        = string
  default     = "main"
}

variable "dismiss_stale_reviews" {
  description = "Dismiss stale pull request reviews"
  type        = bool
  default     = true
}

variable "require_code_owner_reviews" {
  description = "Require code owner reviews"
  type        = bool
  default     = false
}

variable "required_approving_review_count" {
  description = "Number of required approving reviews"
  type        = number
  default     = 1
}

variable "require_up_to_date_before_merge" {
  description = "Require branches to be up to date before merging"
  type        = bool
  default     = false
}

variable "required_status_checks" {
  description = "Required status checks that must pass before merging"
  type        = list(string)
  default     = []
}

variable "enforce_admins" {
  description = "Enforce restrictions for administrators"
  type        = bool
  default     = false
}
