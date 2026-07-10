# Import existing Cloudflare DNS records instead of recreating them.
#
# Workflow for an already-existing record:
#   1. Add it to local.dns_records (records.tf) like any new record.
#   2. Find its Cloudflare record ID: API provides a dump
#   3. Add "<name>-<type>" = "<record_id>" to the map below.
#      The key MUST match the key generated in local.dns_records_map.
#   4. Run plan/apply — Terraform imports the record, then reconciles it to config.
#
# Entries can safely remain after import (they are idempotent) or be removed once
# the record is in state.
locals {
  existing_record_ids = {
    "argo"      = "7365255e3b08de40f88204f5ebfc7625"
    "atlantis"  = "5caf84d979ecda694cef29d743d0e818"
    "auth"      = "91de4cf2ff61be57e9993df094fdbcb8"
    "automate"  = "1ff0076583c614104ea10d89644277c8"
    "blog"      = "6e5e65dd39ebc0499bbe80aca98b42bc"
    "bots"      = "c0bac578fa02b6dc67131ae2b8231c63"
    "chi"       = "519d32448d54a856a13fbb735d666fa1"
    "db"        = "21eb6714925272f228d9c3ffb6d400c9"
    "doit"      = "4ca7b4b6b2460a1eadbe630dafb974ed"
    "draw"      = "0117eb33b6cacf17f539577f2424a46c"
    "gotify"    = "13e38297510e70ae429fbfdb6ef372aa"
    "grafana"   = "86f8b49e259e5095eb802b32f1ce0f4d"
    "paperless" = "c600ac91ab0d2d872fa9fd96eae56c59"
    "s3"        = "ebfaf13fb4f8170efd2f561e842cf3ad"
    "search"    = "6ac181011e30488234a027a3484fa1b7"
    "signoz"    = "979979e59a98055e1f13cd9a6b7a7530"
    "tkd"       = "394a0c292b3045c89a880e46de1ed1c3"
    "umami"     = "df9c8e19fc218958688b8d2601fad375"
    "vault"     = "099706b43f45383ab3be4669709a741f"

  }
}

import {
  for_each = local.existing_record_ids

  to = cloudflare_dns_record.this[each.key]
  id = "${var.cloudflare_zone_id}/${each.value}"
}
