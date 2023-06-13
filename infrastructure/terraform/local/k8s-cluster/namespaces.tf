module "namespace_words" {
  source = "../../modules/namespace"

  name   = "words"
  domain = "app"

  additional_labels = {
    "istio-injection" = "enabled"
  }

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}

module "namespace_istio-system" {
  source = "../../modules/namespace"

  name   = "istio-system"
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

module "namespace_vault" {
  source = "../../modules/namespace"

  name   = "vault"
  domain = "secrets"

  admins  = var.cluster_admins
  editors = var.cluster_managers
  readers = var.cluster_devs
}
