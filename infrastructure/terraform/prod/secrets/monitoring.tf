resource "random_password" "monitoring_grafana-admin-password" {
  length = 16
}

variable "override_monitoring_grafana-admin-password" {
  type        = string
  description = "The password for the Grafana admin user"
  sensitive   = true
  default     = null
}

resource "vault_kv_secret_v2" "monitoring_grafana-admin-password" {
  mount = vault_mount.kvv2.path
  name  = "prod/monitoring/grafana/admin-password"

  data_json = jsonencode(
    {
      password = var.override_monitoring_grafana-admin-password == null ? var.override_monitoring_grafana-admin-password : random_password.monitoring_grafana-admin-password.result
    }
  )
}
