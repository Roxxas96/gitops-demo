resource "kubernetes_role_v1" "namespace-editor" {
  metadata {
    name      = "${var.namespace}-namespace-editor"
    namespace = var.namespace
  }

  rule {
    api_groups = ["", "apps", "extensions"]
    resources = [
      "pods",
      "services",
      "deployments",
      "statefulsets",
      "configmaps",
      "secrets",
      "replicasets",
      "replicationcontrollers",
      "daemonsets",
      "resourcequotas"
    ]
    verbs = ["get", "list", "create", "update", "patch", "watch", "delete"]
  }

  rule {
    api_groups = [""]
    resources = [
      "pods/log",
      "persistentvolumeclaims",
      "events"
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/exec", "pods/portforward"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding_v1" "namespace-editor" {
  count = length(var.users) > 0 ? 1 : 0

  metadata {
    name      = "${var.namespace}-namespace-editor"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.namespace-editor.metadata[0].name
  }

  dynamic "subject" {
    for_each = var.users
    content {
      kind = "User"
      name = subject.value
    }
  }
}
