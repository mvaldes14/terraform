variable "container_name" {
  default = "nginx_node"
  description = "Container Name"
}

variable "container_int_port" {
  default     = 80
  description = "Internal Port"
}

variable "container_ext_port" {
  default     = 80
  description = "External Port"
}