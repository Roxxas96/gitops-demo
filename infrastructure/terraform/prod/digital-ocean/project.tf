variable "project_name" {
  type        = string
  description = "Project name"
  default     = "gitops-demo-preprod"
}

resource "digitalocean_project" "gitops-demo" {
  name = var.project_name
}

resource "digitalocean_project_resources" "gitops-demo" {
  project = digitalocean_project.gitops-demo.id
  resources = [
    digitalocean_kubernetes_cluster.gitops-demo.urn
  ]
}
