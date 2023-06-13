resource "helm_release" "loki" {
  name      = "loki"
  namespace = var.namespace

  chart  = "${path.module}/../../../../helm/loki/chart"
  values = ["${file("${path.module}/../../../../helm/loki/${var.environment}.values.yaml")}"]
}
