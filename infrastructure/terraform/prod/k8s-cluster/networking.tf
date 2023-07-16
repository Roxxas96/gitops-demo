module "networking" {
  source = "../../modules/networking"

  environment = "prod"

  ingress-nginx-namespace = module.namespace_ingress-nginx.namespace
  cert-manager-namespace  = module.namespace_cert-manager.namespace
}
