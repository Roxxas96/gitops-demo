data "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "kubernetes_namespace_v1" "flux-system" {
  metadata {
    name = "flux-system"
  }
}
