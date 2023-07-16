module "namespace_words" {
  source = "../../modules/namespace"

  name   = "words"
  domain = "app"

  quota = {
    requests_cpu    = "2000m"
    requests_memory = "12000Mi"
    limits_cpu      = "2500m"
    limits_memory   = "20000Mi"
  }

  additional_labels = {
    "istio-injection" = "enabled"
  }

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_cert-manager" {
  source = "../../modules/namespace"

  name   = "cert-manager"
  domain = "networking"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_ingress-nginx" {
  source = "../../modules/namespace"

  name   = "ingress-nginx"
  domain = "networking"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_monitoring" {
  source = "../../modules/namespace"

  name   = "monitoring"
  domain = "monitoring"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_argocd" {
  source = "../../modules/namespace"

  name   = "argocd"
  domain = "deployment"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_vault" {
  source = "../../modules/namespace"

  name   = "vault"
  domain = "secrets"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}
