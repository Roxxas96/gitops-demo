module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "prod"

  domain    = var.domain
  namespace = "monitoring"

  minimal_mode = var.minimal_mode
}
