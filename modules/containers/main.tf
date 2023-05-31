terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

# Images
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Resources
resource "docker_container" "nginx-server" {
  name    = var.container_name
  image   = docker_image.nginx.name
  rm      = "true"

  ports {
    internal = var.container_int_port
    external = var.container_ext_port
  }
}

