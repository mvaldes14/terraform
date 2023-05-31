resource "grafana_folder" "general" {
  title = "Homelab"
}

resource "grafana_folder" "containers" {
  title = "Containers"
}

resource "grafana_folder" "network" {
  title = "Network"
}

resource "grafana_dashboard" "Homelab" {
  config_json = file("./json_files/homelab-dashboard.json")
  folder      = grafana_folder.general.id
  depends_on  = [grafana_folder.general]
}

resource "grafana_dashboard" "Pihole" {
  config_json = file("./json_files/pihole-dashboard.json")
  folder      = grafana_folder.network.id
}

resource "grafana_dashboard" "Cloudflare" {
  config_json = file("./json_files/cloudflare-tunnel.json")
  folder      = grafana_folder.general.id
}

resource "grafana_dashboard" "Docker-Engine" {
  config_json = file("./json_files/docker-engine.json")
  folder      = grafana_folder.containers.id
}

resource "grafana_dashboard" "Docker-stack" {
  config_json = file("./json_files/docker-stack.json")
  folder      = grafana_folder.containers.id
}

resource "grafana_dashboard" "Node-exporter" {
  config_json = file("./json_files/node-exporter.json")
  folder      = grafana_folder.general.id
}

resource "grafana_dashboard" "Windows-exporter" {
  config_json = file("./json_files/windows-exporter.json")
  folder      = grafana_folder.general.id
}

resource "grafana_dashboard" "Traefik" {
  config_json = file("./json_files/traefik-dashboard.json")
  folder      = grafana_folder.network.id
}

resource "grafana_dashboard" "Redis" {
  config_json = file("./json_files/redis-dashboard.json")
  folder      = grafana_folder.general.id
}

resource "grafana_dashboard" "Gitea" {
  config_json = file("./json_files/gitea-dashboard.json")
  folder      = grafana_folder.general.id
}
