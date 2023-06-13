resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = var.ingress-nginx-namespace

  chart  = "${path.module}/../../../helm/ingress-nginx/chart"
  values = ["${file("${path.module}/../../../helm/ingress-nginx/${var.environment}.values.yaml")}"]

  count = var.environment == "local" ? 0 : 1
}
