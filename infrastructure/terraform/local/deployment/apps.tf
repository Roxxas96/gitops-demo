data "kubernetes_namespace_v1" "words" {
  metadata {
    name = "words"
  }
}

resource "helm_release" "frontend" {
  name      = "frontend"
  namespace = data.kubernetes_namespace_v1.words.metadata[0].name

  chart  = "../../../../frontend/containers/helm/chart"
  values = ["${file("../../../../frontend/containers/helm/local.values.yaml")}"]

  set {
    name  = "config.services_url"
    value = "http://localhost:8081;http://localhost:8082;http://localhost:8083"
  }
}

resource "helm_release" "word-service-1" {
  name      = "word-service-1"
  namespace = data.kubernetes_namespace_v1.words.metadata[0].name

  chart  = "../../../../word-service/containers/helm/chart"
  values = ["${file("../../../../word-service/containers/helm/local.values.yaml")}"]

  set {
    name  = "config.database_name"
    value = "word1"
  }

  set {
    name  = "config.service_name"
    value = "word-1"
  }
}

resource "helm_release" "word-service-2" {
  name      = "word-service-2"
  namespace = data.kubernetes_namespace_v1.words.metadata[0].name

  chart  = "../../../../word-service/containers/helm/chart"
  values = ["${file("../../../../word-service/containers/helm/local.values.yaml")}"]

  set {
    name  = "config.database_name"
    value = "word2"
  }

  set {
    name  = "config.service_name"
    value = "word-2"
  }
}

resource "helm_release" "word-service-3" {
  name      = "word-service-3"
  namespace = data.kubernetes_namespace_v1.words.metadata[0].name

  chart  = "../../../../word-service/containers/helm/chart"
  values = ["${file("../../../../word-service/containers/helm/local.values.yaml")}"]

  set {
    name  = "config.database_name"
    value = "word3"
  }

  set {
    name  = "config.service_name"
    value = "word-3"
  }
}
