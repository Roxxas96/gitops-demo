resource "helm_release" "postgres" {
  name      = "postgres"
  namespace = module.review-namespace.namespace

  chart  = "../../helm/postgresql/chart"
  values = ["${file("../../helm/postgresql/preprod.values.yaml")}"]

  set_sensitive {
    name  = "global.postgresql.auth.postgresPassword"
    value = vault_kv_secret_v2.database-password.data["password"]
  }
}
