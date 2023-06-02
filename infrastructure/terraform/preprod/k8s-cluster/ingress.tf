module "ingress" {
  source = "../../modules/ingress"

  environment = "preprod"

  ingress-nginx-namespace = module.namespace_ingress-nginx[0].namespace
  cert-manager-namespace  = module.namespace_cert-manager[0].namespace

  count = var.enable_ingress ? 1 : 0
}
