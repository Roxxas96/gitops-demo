resource "kubectl_manifest" "database_service-monitor" {
  yaml_body = <<YAML
    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      labels:
        release: kube-prometheus-stack
      name: postgres-postgresql
      namespace: monitoring
    spec:
      endpoints:
      - port: http-metrics
      namespaceSelector:
        matchNames:
        - review-feat-review-environment
      selector:
        matchLabels:
          app.kubernetes.io/component: metrics
          app.kubernetes.io/instance: postgres
          app.kubernetes.io/name: postgresql
    YAML
}
