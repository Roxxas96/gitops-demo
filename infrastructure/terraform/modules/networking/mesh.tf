resource "helm_release" "istio-base" {
  name      = "istio-base"
  namespace = var.istio-namespace

  chart  = "${path.module}/../../../helm/istio/base/chart"
  values = ["${file("${path.module}/../../../helm/istio/base/${var.environment}.values.yaml")}"]
}

resource "helm_release" "istio-istiod" {
  name      = "istio-istiod"
  namespace = var.istio-namespace

  chart  = "${path.module}/../../../helm/istio/istiod/chart"
  values = ["${file("${path.module}/../../../helm/istio/istiod/${var.environment}.values.yaml")}"]

  depends_on = [
    helm_release.istio-base
  ]
}

resource "helm_release" "istio-config" {
  name      = "istio-config"
  namespace = var.istio-namespace

  chart  = "${path.module}/../../../helm/istio-config/chart"
  values = ["${file("${path.module}/../../../helm/istio-config/${var.environment}.values.yaml")}"]

  depends_on = [
    helm_release.istio-istiod
  ]
}
