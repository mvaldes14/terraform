resource "grafana_contact_point" "telegram" {
  name = "telegram"

  telegram {
    token   = var.TELEGRAM_TOKEN
    chat_id = var.TELEGRAM_CHAT_ID
  }
}

resource "grafana_notification_policy" "telegram" {
  group_by      = ["..."]
  contact_point = grafana_contact_point.telegram.name

  group_wait      = "45s"
  group_interval  = "6m"
  repeat_interval = "3h"

  policy {
    matcher {
      label = "homelab"
      match = "="
      value = "enabled"
    }
    contact_point = grafana_contact_point.telegram.name
    group_by      = ["..."]
  }
}
