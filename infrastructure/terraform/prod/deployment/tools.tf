data "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "vault_kv_secret_v2" "argocd_admin-password" {
  name  = "prod/deployment/argocd/admin-password"
  mount = "kvv2"
}

resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = data.kubernetes_namespace_v1.argocd.metadata[0].name

  chart  = "../../../helm/argo-cd/chart"
  values = ["${file("../../../helm/argo-cd/prod.values.yaml")}"]

  set_sensitive {
    name = "configs.secret.argocdServerAdminPassword"
    # Bcrypt hash of the password
    value = data.vault_kv_secret_v2.argocd_admin-password.data["password"]
  }
}

data "kubernetes_service_v1" "argocd" {
  metadata {
    name      = "argocd-server"
    namespace = data.kubernetes_namespace_v1.argocd.metadata[0].name
  }

  depends_on = [
    helm_release.argocd
  ]
}

resource "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd"
    namespace = data.kubernetes_namespace_v1.argocd.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                  = "nginx"
      "cert-manager.io/cluster-issuer"               = "letsencrypt-prod-issuer"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }

  spec {
    tls {
      hosts       = ["argo.${var.domain}"]
      secret_name = "argocd-tls"
    }
    rule {
      host = "argo.${var.domain}"

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service_v1.argocd.metadata[0].name
              port {
                number = data.kubernetes_service_v1.argocd.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }

  count = var.minimal_mode ? 0 : 1
}
