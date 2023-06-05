resource "helm_release" "loki" {
  name      = "loki"
  namespace = data.kubernetes_namespace_v1.monitoring.metadata[0].name

  chart  = "${path.module}/../../../../helm/loki/chart"
  values = ["${file("${path.module}/../../../../helm/loki/${var.minimal_mode ? "local" : var.environment}.values.yaml")}"]
}
