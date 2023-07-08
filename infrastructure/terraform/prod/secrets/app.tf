resource "random_password" "app_word-service-database-password" {
  length = 16
}

variable "override_app_word-service-database-password" {
  type        = string
  description = "The password for the Word Service database"
  sensitive   = true
  default     = null
}

resource "vault_kv_secret_v2" "app_word-service-database-password" {
  mount = vault_mount.kvv2.path
  name  = "prod/app/word-service/database/password"

  data_json = jsonencode(
    {
      password = var.override_app_word-service-database-password == null ? var.override_app_word-service-database-password : random_password.app_word-service-database-password.result
    }
  )
}
