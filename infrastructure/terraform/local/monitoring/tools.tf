module "monitoring-tools" {
  source = "../../modules/monitoring/tools"

  environment = "local"

  namespace = "monitoring"
}
