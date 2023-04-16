resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = var.name
    labels = {
      domain = var.domain
    }
  }
}

resource "kubernetes_resource_quota_v1" "quota" {
  count = var.quota == null ? 0 : 1

  metadata {
    name      = "${var.name}-quota"
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = var.quota.requests_cpu
      "requests.memory" = var.quota.requests_memory
      "limits.cpu"      = var.quota.limits_cpu
      "limits.memory"   = var.quota.limits_memory
    }
  }
}

module "namespace-readers" {
  source = "./roles/namespace-reader"

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  users     = var.readers
}

module "namespace-editors" {
  source = "./roles/namespace-editor"

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  users     = var.editors
}

module "namespace-admins" {
  source = "./roles/namespace-admin"

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  users     = var.admins
}
