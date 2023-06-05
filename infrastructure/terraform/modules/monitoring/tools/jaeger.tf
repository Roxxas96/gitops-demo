resource "helm_release" "jaeger" {
  name      = "jaeger"
  namespace = data.kubernetes_namespace_v1.monitoring.metadata[0].name

  chart  = "${path.module}/../../../../helm/jaeger/chart"
  values = ["${file("${path.module}/../../../../helm/jaeger/${var.minimal_mode ? "local" : var.environment}.values.yaml")}"]

  set {
    name  = "allInOne.args[5]"
    value = "http://${helm_release.kube-prometheus-stack.name}-prometheus:9090"
  }
}
