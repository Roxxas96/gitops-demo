module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "prod"

  domain                          = var.domain
  kube-prometheus-stack-namespace = "kube-prometheus-stack"

  minimal_mode = var.minimal_mode
}
