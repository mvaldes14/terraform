output "webserver-ip" {
  value = docker_container.nginx-server.ip_address
}