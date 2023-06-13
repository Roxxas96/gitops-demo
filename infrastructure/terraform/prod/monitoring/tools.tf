module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "prod"

  domain    = var.domain
  namespace = "monitoring"
}
