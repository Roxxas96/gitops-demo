module "namespace_words" {
  source = "../../modules/namespace"

  name   = "words"
  domain = "app"

  quota = {
    requests_cpu    = "1400m"
    requests_memory = "1792Mi"
    limits_cpu      = "2200m"
    limits_memory   = "2816Mi"
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
  domain = "ingress"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_ingress-nginx" {
  source = "../../modules/namespace"

  name   = "ingress-nginx"
  domain = "ingress"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_kube-prometheus-stack" {
  source = "../../modules/namespace"

  name   = "kube-prometheus-stack"
  domain = "monitoring"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}
