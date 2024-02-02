resource "grafana_folder" "homelab" {
  title = "Homelab"
}

resource "grafana_folder" "network" {
  title = "Network"
}

resource "grafana_dashboard" "Homelab" {
  config_json = file("./json_files/homelab-dashboard.json")
  folder      = grafana_folder.homelab.id
  depends_on  = [grafana_folder.homelab]
}

resource "grafana_dashboard" "Pihole" {
  config_json = file("./json_files/pihole-dashboard.json")
  folder      = grafana_folder.network.id
}

resource "grafana_dashboard" "Cloudflare" {
  config_json = file("./json_files/cloudflare-tunnel.json")
  folder      = grafana_folder.homelab.id
}

resource "grafana_dashboard" "Node-exporter" {
  config_json = file("./json_files/node-exporter.json")
  folder      = grafana_folder.homelab.id
}

resource "grafana_dashboard" "Traefik" {
  config_json = file("./json_files/traefik-dashboard.json")
  folder      = grafana_folder.network.id
}

resource "grafana_dashboard" "Elasticsearch" {
  config_json = file("./json_files/elasticsearch-dashboard.json")
  folder      = grafana_folder.homelab.id
}
