data "vault_kv_secret_v2" "gitops-demo_ssh-key" {
  mount = "kvv2"
  name  = "prod/deployment/repositories/gitops-demo/ssh-key"
}

data "vault_kv_secret_v2" "app_database-password" {
  mount = "kvv2"
  name  = "prod/app/word-service/database/password"
}

resource "helm_release" "argocd-config" {
  name      = "argocd-config"
  namespace = data.kubernetes_namespace_v1.argocd.metadata[0].name

  chart  = "../../../helm/argo-cd-config/chart"
  values = ["${file("../../../helm/argo-cd-config/${var.minimal_mode ? "local" : "prod"}.values.yaml")}"]

  set_sensitive {
    name  = "repositories.gitops-demo.ssh.privateKey"
    value = data.vault_kv_secret_v2.gitops-demo_ssh-key.data["private_key"]
  }

  depends_on = [
    helm_release.argocd,
  ]
}
