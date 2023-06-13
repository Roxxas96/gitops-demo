variable "app_database-password" {
  type        = string
  description = "The password for the Database admin user"
  default     = "admin"
}

resource "vault_kv_secret_v2" "app_database-password" {
  mount = vault_mount.kvv2.path
  name  = "local/app/word-service/database/password"

  data_json = jsonencode({
    password = var.app_database-password
  })
}
