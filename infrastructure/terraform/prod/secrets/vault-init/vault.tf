data "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

module "vault" {
  source = "../../../modules/secrets/tools"

  environment = "prod"
  namespace   = data.kubernetes_namespace_v1.vault.metadata[0].name

  domain = var.domain
}
