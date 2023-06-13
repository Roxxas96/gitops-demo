module "networking" {
  source = "../../modules/networking"

  environment = "local"

  istio-namespace = module.namespace_istio-system.namespace
}
