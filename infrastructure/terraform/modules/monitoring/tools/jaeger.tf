resource "helm_release" "jaeger" {
  name      = "jaeger"
  namespace = var.namespace

  chart  = "${path.module}/../../../../helm/jaeger/chart"
  values = ["${file("${path.module}/../../../../helm/jaeger/${var.environment}.values.yaml")}"]

  set {
    name  = "allInOne.args[5]"
    value = "http://${helm_release.kube-prometheus-stack.name}-prometheus:9090"
  }
}
