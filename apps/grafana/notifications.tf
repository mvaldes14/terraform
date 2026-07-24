resource "grafana_contact_point" "gotify" {
  name = "Gotify"

  webhook {
    url                       = "http://gotify-svc.gotify/message"
    http_method               = "POST"
    authorization_scheme      = "Bearer"
    authorization_credentials = var.gotify_token
  }
}

resource "grafana_notification_policy" "gotify" {
  group_by      = ["..."]
  contact_point = grafana_contact_point.gotify.name
}
