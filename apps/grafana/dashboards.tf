resource "grafana_folder" "homelab" {
  title = "Homelab"
}

resource "grafana_dashboard" "Homelab" {
  config_json = file("./json_files/homelab-monitors.json")
  folder      = grafana_folder.homelab.id
  depends_on  = [grafana_folder.homelab]
}

resource "grafana_dashboard" "Cloudflare" {
  config_json = file("./json_files/cloudflared-tunnel.json")
  folder      = grafana_folder.homelab.id
}

resource "grafana_dashboard" "Node-exporter" {
  config_json = file("./json_files/node_exporter.json")
  folder      = grafana_folder.homelab.id
}

resource "grafana_dashboard" "Flux" {
  config_json = file("./json_files/flux.json")
  folder      = grafana_folder.homelab.id
}

resource "grafana_dashboard" "Prometheus" {
  config_json = file("./json_files/prometheus.json")
  folder      = grafana_folder.homelab.id
}
