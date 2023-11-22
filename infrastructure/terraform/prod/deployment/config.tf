data "vault_kv_secret_v2" "gitops-demo_ssh-key" {
  mount = "kvv2"
  name  = "prod/deployment/repositories/gitops-demo/ssh-key"
}

data "vault_kv_secret_v2" "app_database-password" {
  mount = "kvv2"
  name  = "prod/app/word-service/database/password"
}

resource "helm_release" "argocd-config" {
  name      = "argocd-config"
  namespace = data.kubernetes_namespace_v1.argocd.metadata[0].name

  chart = "../../../helm/argo-cd-config/chart"
  values = [templatefile("../../../helm/argo-cd-config/prod.values.yaml", {
    domain = var.domain
  })]

  set_sensitive {
    name  = "repositories.gitops-demo.ssh.privateKey"
    value = data.vault_kv_secret_v2.gitops-demo_ssh-key.data["private_key"]
  }

  depends_on = [
    helm_release.argocd,
  ]
}

variable "repository_gitops-demo_url" {
  type        = string
  description = "The URL of the repository"
  default     = "https://github.com/Roxxas96/gitops-demo"
}

variable "repository_gitops-demo_main-branch" {
  type        = string
  description = "The main branch of the repository"
  default     = "test/flux-dday"
}

locals {
  repository_gitops-demo_name = "gitops-demo"
}

resource "kubectl_manifest" "repository_gitops-demo" {
  yaml_body = <<YAML
    apiVersion: source.toolkit.fluxcd.io/v1
    kind: GitRepository
    metadata:
      name: ${local.repository_gitops-demo_name}
      namespace: ${data.kubernetes_namespace_v1.flux-system.metadata[0].name}
    spec:
      interval: 30s
      url: ${var.repository_gitops-demo_url}
      ref:
        branch: ${var.repository_gitops-demo_main-branch}
    YAML

  depends_on = [helm_release.fluxcd]
}

variable "kubeconfig-prod" {
  type        = string
  description = "The kubeconfig file for the prod cluster that will be used by fluxcd"
  sensitive   = true
}

resource "kubernetes_secret_v1" "kubeconfig-prod" {
  metadata {
    name      = "kubeconfig-prod"
    namespace = data.kubernetes_namespace_v1.flux-system.metadata[0].name
  }
  data = {
    kubeconfig = var.kubeconfig-prod
  }
}

variable "terraform_k8s-cluster_repo_file_path" {
  type        = string
  description = "The path to the Terraform files inside the repository"
  default     = "infrastructure/terraform/prod/k8s-cluster"
}

resource "kubectl_manifest" "terraform_k8s-cluster" {
  yaml_body = <<YAML
    apiVersion: infra.contrib.fluxcd.io/v1alpha2
    kind: Terraform
    metadata:
      name: k8s-cluster
      namespace: ${data.kubernetes_namespace_v1.flux-system.metadata[0].name}
    spec:
      interval: 30s
      approvePlan: auto
      path: ${var.terraform_k8s-cluster_repo_file_path}
      sourceRef:
        kind: GitRepository
        name: ${local.repository_gitops-demo_name}
        namespace: ${data.kubernetes_namespace_v1.flux-system.metadata[0].name}
      varsFrom:
        - kind: Secret
          name: tfvars-k8s-cluster
      fileMappings:
        - location: home
          path: .kube/gitops-demo-prod.kubeconfig
          secretRef:
            name: kubeconfig-prod
            key: kubeconfig
      backendConfig:
        customConfiguration: |
          backend "${var.backend_k8s-cluster.type}" {
            ${join("\n            ", [for key, value in var.backend_k8s-cluster.config : "${key} = \"${value}\""])}
          }
    YAML 
}

variable "tfvars_k8s-cluster" {
  type        = map(string)
  description = "The Terraform variables that will be used by fluxcd for the k8s-cluster Terraform module"
  sensitive   = true
}

resource "kubernetes_secret_v1" "tfvars_k8s-cluster" {
  metadata {
    name      = "tfvars-k8s-cluster"
    namespace = data.kubernetes_namespace_v1.flux-system.metadata[0].name
  }
  data = var.tfvars_k8s-cluster
}

variable "backend_k8s-cluster" {
  type = object({
    type   = string
    config = map(string)
  })
  description = "The Terraform backend configuration that will be used by fluxcd for the k8s-cluster Terraform module"
  sensitive   = true
}
