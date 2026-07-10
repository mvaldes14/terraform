# SigNoz

Manages SigNoz dashboards, alerts, and access as code via the
[`SigNoz/signoz`](https://registry.terraform.io/providers/SigNoz/signoz/latest) provider.

> **Status: stub.** Provider is wired up; resource files (`dashboards.tf`,
> `alerts.tf`) contain commented examples to fill in.

## Layout

| File           | Purpose                                                        |
| -------------- | ------------------------------------------------------------- |
| `providers.tf` | `SigNoz/signoz` `0.0.15`, endpoint + token auth               |
| `state.tf`     | Terraform Cloud workspace `signoz` (org `mvaldes`)           |
| `variables.tf` | `signoz_endpoint`                                            |
| `dashboards.tf`| `signoz_dashboard` resources (stubbed)                       |
| `alerts.tf`    | `signoz_alert` resources (stubbed)                           |

## Auth

Provider reads `SIGNOZ_ACCESS_TOKEN` from the environment — set it as a sensitive
env var in the `signoz` Terraform Cloud workspace. The endpoint defaults to
`https://signoz.mvaldes.dev` (`var.signoz_endpoint`).

## Available resources

`signoz_dashboard`, `signoz_alert`, `signoz_planned_maintenance`, `signoz_role`,
`signoz_route_policy`, `signoz_user`, `signoz_service_account` (+ role bindings).

## Import existing

Dashboards/alerts already in SigNoz import by ID:

```bash
terraform import signoz_dashboard.homelab <dashboard-uuid>
```
