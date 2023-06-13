data "kubernetes_namespace_v1" "words" {
  metadata {
    name = "words"
  }
}

module "storage" {
  source = "../../modules/app/storage"

  environment = "local"

  words-namespace = data.kubernetes_namespace_v1.words.metadata[0].name
}
