data "vault_kv_secret_v2" "app_database-password" {
  mount = "kvv2"
  name  = "prod/app/word-service/database/password"
}

resource "helm_release" "postgres" {
  name      = "postgres"
  namespace = var.words-namespace

  chart  = "${path.module}/../../../../helm/postgresql/chart"
  values = ["${file("${path.module}/../../../../helm/postgresql/${var.environment}.values.yaml")}"]

  set_sensitive {
    name  = "global.postgresql.auth.postgresPassword"
    value = data.vault_kv_secret_v2.app_database-password.data["password"]
  }
}
