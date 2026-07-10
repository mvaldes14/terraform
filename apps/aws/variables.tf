variable "region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name, applied to every resource via default_tags"
  default     = "homelab"
}
