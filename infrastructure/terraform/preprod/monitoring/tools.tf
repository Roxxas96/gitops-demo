module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "preprod"

  domain    = var.domain
  namespace = "monitoring"
}
