resource "kubernetes_role_v1" "namespace-admin" {
  metadata {
    name      = "${var.namespace}-namespace-admin"
    namespace = var.namespace
  }

  rule {
    api_groups = ["", "apps", "extensions", "batch", "autoscaling"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding_v1" "namespace-admin" {
  count = length(var.users) > 0 ? 1 : 0

  metadata {
    name      = "${var.namespace}-namespace-admin"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.namespace-admin.metadata[0].name
  }

  dynamic "subject" {
    for_each = var.users
    content {
      kind = "User"
      name = subject.value
    }
  }
}
