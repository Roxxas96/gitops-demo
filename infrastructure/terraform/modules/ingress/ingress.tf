resource "helm_release" "ingress-nginx" {
  name      = "ingress-nginx"
  namespace = var.ingress-nginx-namespace

  chart  = "${path.module}/../../../helm/ingress-nginx/chart"
  values = ["${file("${path.module}/../../../helm/ingress-nginx/${var.environment}.values.yaml")}"]
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = var.cert-manager-namespace

  chart  = "${path.module}/../../../helm/cert-manager/chart"
  values = ["${file("${path.module}/../../../helm/cert-manager/${var.environment}.values.yaml")}"]
}

resource "helm_release" "cert-manager-issuers" {
  name      = "cert-manager-issuers"
  namespace = var.cert-manager-namespace

  chart  = "${path.module}/../../../helm/cert-manager-issuers/chart"
  values = ["${file("${path.module}/../../../helm/cert-manager-issuers/${var.environment}.values.yaml")}"]

  depends_on = [
    helm_release.cert-manager
  ]
}
