resource "helm_release" "vault" {
  name      = "vault"
  namespace = var.namespace

  chart  = "../../../../helm/vault/chart"
  values = ["${file("../../../../helm/vault/${var.environment}.values.yaml")}"]
}

data "kubernetes_service_v1" "vault" {
  metadata {
    name      = "vault"
    namespace = var.namespace
  }

  depends_on = [
    helm_release.vault
  ]
}

resource "kubernetes_ingress_v1" "vault" {
  metadata {
    name      = "vault"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["vault.${var.domain}"]
      secret_name = "vault-tls"
    }
    rule {
      host = "vault.${var.domain}"

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service_v1.vault.metadata[0].name
              port {
                number = data.kubernetes_service_v1.vault.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }

  count = var.environment == "local" ? 0 : 1
}
