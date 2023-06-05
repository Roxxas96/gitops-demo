module "ingress" {
  source = "../../modules/ingress"

  environment = "prod"

  ingress-nginx-namespace = module.namespace_ingress-nginx[0].namespace
  cert-manager-namespace  = module.namespace_cert-manager[0].namespace

  count = var.minimal_mode ? 0 : 1
}
