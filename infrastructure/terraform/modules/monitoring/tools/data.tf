data "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}
