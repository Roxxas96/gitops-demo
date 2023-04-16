resource "kubernetes_role_v1" "namespace-reader" {
  metadata {
    name      = "${var.namespace}-namespace-reader"
    namespace = var.namespace
  }

  rule {
    api_groups = ["", "apps", "extensions"]
    resources = [
      "pods",
      "pods/log",
      "services",
      "deployments",
      "statefulsets",
      "configmaps",
      "replicasets",
      "replicationcontrollers",
      "daemonsets",
      "ingresses",
      "persistentvolumeclaims",
    ]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "namespace-reader" {
  count = length(var.users) > 0 ? 1 : 0

  metadata {
    name      = "${var.namespace}-namespace-reader"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.namespace-reader.metadata[0].name
  }

  dynamic "subject" {
    for_each = var.users
    content {
      kind = "User"
      name = subject.value
    }
  }
}
