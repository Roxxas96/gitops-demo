data "kubernetes_namespace_v1" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  name      = "vault"
  namespace = data.kubernetes_namespace_v1.vault.metadata[0].name

  chart  = "../../../../helm/vault/chart"
  values = ["${file("../../../../helm/vault/prod.values.yaml")}"]
}

data "kubernetes_service_v1" "vault" {
  metadata {
    name      = "vault"
    namespace = data.kubernetes_namespace_v1.vault.metadata[0].name
  }

  depends_on = [
    helm_release.vault
  ]
}

resource "kubernetes_ingress_v1" "vault" {
  metadata {
    name      = "vault"
    namespace = data.kubernetes_namespace_v1.vault.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-issuer"
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
}
