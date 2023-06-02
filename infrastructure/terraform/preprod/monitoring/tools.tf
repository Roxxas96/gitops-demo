module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "preprod"

  domain                          = var.domain
  kube-prometheus-stack-namespace = "kube-prometheus-stack"

  enable_ingress = var.enable_ingress
}
