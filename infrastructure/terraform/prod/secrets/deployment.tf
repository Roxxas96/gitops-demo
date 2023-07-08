resource "random_password" "deployment_argocd-admin-password" {
  length = 16
}

variable "override_deployment_argocd-admin-password" {
  type        = string
  description = "The password for the ArgoCD admin user"
  sensitive   = true
  default = null
}

resource "vault_kv_secret_v2" "deployment_argocd-admin-password" {
  mount = vault_mount.kvv2.path
  name  = "prod/deployment/argocd/admin-password"

  data_json = jsonencode(
    {
      password = var.override_deployment_argocd-admin-password == null ? var.override_deployment_argocd-admin-password : random_password.deployment_argocd-admin-password.bcrypt_hash
    }
  )
}

variable "gitops-demo_ssh-key" {
  type        = string
  description = "The private key for the GitOps repository"
  sensitive   = true
}

resource "vault_kv_secret_v2" "deployment_gitops-demo-ssh-key" {
  mount = vault_mount.kvv2.path
  name  = "prod/deployment/repositories/gitops-demo/ssh-key"

  data_json = jsonencode(
    {
      private_key = var.gitops-demo_ssh-key
    }
  )
}
