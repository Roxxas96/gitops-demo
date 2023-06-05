resource "helm_release" "otel-operator" {
  name      = "otel-operator"
  namespace = data.kubernetes_namespace_v1.monitoring.metadata[0].name

  chart  = "${path.module}/../../../../helm/opentelemetry-operator/chart"
  values = ["${file("${path.module}/../../../../helm/opentelemetry-operator/${var.minimal_mode ? "local" : var.environment}.values.yaml")}"]
}

resource "helm_release" "otel-config" {
  name      = "otel-config"
  namespace = data.kubernetes_namespace_v1.monitoring.metadata[0].name

  chart  = "${path.module}/../../../../helm/opentelemetry-config/chart"
  values = ["${file("${path.module}/../../../../helm/opentelemetry-config/${var.minimal_mode ? "local" : var.environment}.values.yaml")}"]

  set {
    name  = "collectors.main.otlpEndpoint"
    value = "${helm_release.jaeger.name}-collector:4317"
  }

  depends_on = [helm_release.otel-operator]
}

resource "kubernetes_service_v1" "otel-collector-prometheus-exporter" {
  metadata {
    name      = "main-collector-prometheus-exporter"
    namespace = data.kubernetes_namespace_v1.monitoring.metadata[0].name

    labels = {
      "app.kubernetes.io/component" = "opentelemetry-collector"
      "app.kubernetes.io/name"      = "main-collector-prometheus-exporter"
      "app.kubernetes.io/part-of"   = "opentelemetry"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name"       = "main-collector"
      "app.kubernetes.io/component"  = "opentelemetry-collector"
      "app.kubernetes.io/managed-by" = "opentelemetry-operator"
      "app.kubernetes.io/part-of"    = "opentelemetry"
    }

    port {
      name        = "prometheus-exporter"
      port        = 9464
      target_port = 9464
    }
  }
}
