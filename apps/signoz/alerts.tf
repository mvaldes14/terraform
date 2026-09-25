resource "signoz_rule" "test_terraform" {
  alert      = "[test][terraform] Alert by Provider"
  alert_type = "METRIC_BASED_ALERT"
  rule_type  = "threshold_rule"
  disabled   = true 

  annotations = {
    description = "Pod {{$k8s.pod.name}} CPU is at {{$value}}."
    summary     = "Pod CPU above {{$threshold}} of request"
  }

  condition = {
    composite_query = {
      panel_type = "graph"
      query_type = "builder"

      queries = [
        {
          builder_query = {
            type = "builder_query"
            spec = {
              metrics = {
                name   = "A"
                signal = "metrics"

                aggregations = [
                  {
                    metric_name       = "k8s.pod.cpu_request_utilization"
                    space_aggregation = "max"
                    time_aggregation  = "max"
                  }
                ]

                group_by = [
                  {
                    field_context   = "resource"
                    field_data_type = "string"
                    name            = "k8s.pod.name"
                  },
                ]

                legend        = "{{k8s.pod.name}}"
                step_interval = "60"
              }
            }
          }
        }
      ]
    }

    selected_query_name = "A"

    thresholds = {
      basic = {
        kind = "basic"
        spec = [
          {
            channels = [
              "n8n",
              "Email"
            ]
            match_type = "all_the_times"
            name       = "critical"
            op         = "above"
            target     = 0.8
          }
        ]
      }
    }
  }

  description = "CPU usage for api-service pods exceeds 80% of the requested CPU"

  evaluation = {
    rolling = {
      kind = "rolling"
      spec = {
        eval_window = "15m"
        frequency   = "1m"
      }
    }
  }

  labels = {
    severity = "critical"
    team     = "platform"
  }

  notification_settings = {
    group_by = ["k8s.pod.name"]
    renotify = {
      alert_states = ["firing"]
      enabled      = true
      interval     = "4h"
    }
  }

  schema_version = "v2alpha1"
}
