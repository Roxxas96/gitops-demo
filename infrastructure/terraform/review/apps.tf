data "kubernetes_namespace_v1" "argocd-namespace" {
  metadata {
    name = "argocd"
  }
}

resource "kubectl_manifest" "app_frontend" {
  yaml_body = <<YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ${local.formated_target}-frontend
      namespace: ${data.kubernetes_namespace_v1.argocd-namespace.metadata.0.name}
    spec:
      project: review
      source:
        repoURL: git@github.com:Roxxas96/gitops-demo.git
        targetRevision: "${var.target}"
        path: frontend/containers/helm/chart
        helm:
          releaseName: frontend
          valueFiles:
            - ../prod.values.yaml
          parameters:
            - name: image.tag
              value: "${local.formated_target}-${var.target_sha}"
            - name: config.services_url
              value: "https://${local.formated_target}.word-1.${var.domain};https://${local.formated_target}.word-2.${var.domain};https://${local.formated_target}.word-3.${var.domain}"
            - name: ingress.hosts[0].host
              value: "www.${local.formated_target}.${var.domain}"
            - name: ingress.tls[0].hosts[0]
              value: "www.${local.formated_target}.${var.domain}"
            - name: ingress.tls[0].secretName
              value: "frontend-tls"
      destination:
        server: https://kubernetes.default.svc
        namespace: ${module.review-namespace.namespace}
      syncPolicy:
        automated: {}
    YAML
}

resource "kubectl_manifest" "app_word-service" {
  count = 3

  yaml_body = <<YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: ${local.formated_target}-word-service-${count.index + 1}
      namespace: ${data.kubernetes_namespace_v1.argocd-namespace.metadata.0.name}
    spec:
      project: review
      source:
        repoURL: git@github.com:Roxxas96/gitops-demo.git
        targetRevision: "${var.target}"
        path: word-service/containers/helm/chart
        helm:
          releaseName: word-service-${count.index + 1}
          valueFiles:
            - ../prod.values.yaml
          parameters:
            - name: image.tag
              value: "${local.formated_target}-${var.target_sha}"
            - name: config.database_name
              value: "word${count.index + 1}"
            - name: config.service_name
              value: "word-${count.index + 1}"
            - name: ingress.hosts[0].host
              value: "${local.formated_target}.word-${count.index + 1}.${var.domain}"
            - name: ingress.tls[0].hosts[0]
              value: "${local.formated_target}.word-${count.index + 1}.${var.domain}"
            - name: ingress.tls[0].secretName
              value: "word-${count.index + 1}-tls"
      destination:
        server: https://kubernetes.default.svc
        namespace: ${module.review-namespace.namespace}
      syncPolicy:
        automated: {}
    YAML
}
