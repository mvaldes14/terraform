# ─── Dashboards ───────────────────────────────────────────────────────────────
# STUB — uncomment and fill in to manage SigNoz dashboards as code.
# The layout/widgets/variables fields are JSON strings; use jsonencode() or
# file() to load them from a dashboards/ directory.
# Docs: https://registry.terraform.io/providers/SigNoz/signoz/latest/docs/resources/dashboard
#
# resource "signoz_dashboard" "homelab" {
#   name                      = "homelab"
#   title                     = "Homelab Overview"
#   description               = "Homelab service metrics"
#   version                   = "v4"
#   collapsable_rows_migrated = true
#   uploaded_grafana          = false
#   tags                      = ["homelab"]
#   layout                    = jsonencode([])
#   widgets                   = jsonencode([])
#   variables                 = jsonencode({})
# }
