resource "random_password" "database-password" {
  length = 16
}

variable "override_database-password" {
  type        = string
  description = "The password for the Word Service database"
  sensitive   = true
  default     = null
}

resource "vault_kv_secret_v2" "database-password" {
  mount = "kvv2"
  name  = "review/${local.formated_target}/app/word-service/database/password"

  data_json = jsonencode(
    {
      password = var.override_database-password == null ? random_password.database-password.result : var.override_database-password
    }
  )
}
