variable "grafana_admin-password" {
  type        = string
  description = "The password for the Grafana admin user"
  default     = "admin"
}

resource "vault_kv_secret_v2" "grafana_admin-password" {
  mount = vault_mount.kvv2.path
  name  = "local/monitoring/grafana/admin-password"

  data_json = jsonencode({
    password = var.grafana_admin-password
  })
}
