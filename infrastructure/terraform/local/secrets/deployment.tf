variable "argocd_admin-password" {
  type        = string
  description = "The password for the argocd admin user"
  default     = "admin"
}

resource "vault_kv_secret_v2" "argocd_admin-password" {
  mount = vault_mount.kvv2.path
  name  = "local/deployment/argocd/admin-password"

  data_json = jsonencode({
    password = bcrypt(var.argocd_admin-password)
  })
}

variable "gitops-demo_ssh-key" {
  type        = string
  description = "The private key for the gitops-demo repository"
  sensitive   = true
}

resource "vault_kv_secret_v2" "gitops-demo_ssh-key" {
  mount = vault_mount.kvv2.path
  name  = "local/deployment/repositories/gitops-demo/ssh-key"

  data_json = jsonencode({
    private_key = var.gitops-demo_ssh-key
  })
}
