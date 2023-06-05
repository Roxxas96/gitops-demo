module "namespace_words" {
  source = "../../modules/namespace"

  name   = "words"
  domain = "app"

  # quota = {
  #   requests_cpu    = "400m"
  #   requests_memory = "512Mi"
  #   limits_cpu      = "600m"
  #   limits_memory   = "768Mi"
  # }

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

  count = var.minimal_mode ? 1 : 0
}

module "namespace_ingress-nginx" {
  source = "../../modules/namespace"

  name   = "ingress-nginx"
  domain = "ingress"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs

  count = var.minimal_mode ? 1 : 0
}

module "namespace_kube-prometheus-stack" {
  source = "../../modules/namespace"

  name   = "kube-prometheus-stack"
  domain = "monitoring"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}
