module "networking" {
  source = "../../modules/networking"

  environment = "prod"

  ingress-nginx-namespace = module.namespace_ingress-nginx[0].namespace
  cert-manager-namespace  = module.namespace_cert-manager[0].namespace
  istio-namespace         = module.namespace_istio-system.namespace
}
