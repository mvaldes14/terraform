provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "docker_demo" {
  source             = "./modules/containers"
  count              = 2
  container_name     = "my_nginx_server_${count.index}"
  container_int_port = 80
  container_ext_port = 8000 + count.index
}
