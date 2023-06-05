module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "preprod"

  domain                          = var.domain
  kube-prometheus-stack-namespace = "kube-prometheus-stack"

  minminimal_mode = var.minimal_mode
}
