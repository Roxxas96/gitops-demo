variable "kubernetes_cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.28.2-do.0"
}

variable "kubernetes_cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
  default     = "gitops-demo-prod"
}

variable "kubernetes_cluster_region" {
  type        = string
  description = "Kubernetes cluster region"
}

variable "default_node_pools" {
  type = list(object({
    name       = string
    size       = string
    auto_scale = bool
    min_nodes  = number
    max_nodes  = number
  }))
  description = "The default node pool(s) configuration"
  default = [{
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }]
}

resource "digitalocean_kubernetes_cluster" "gitops-demo" {
  name    = var.kubernetes_cluster_name
  region  = var.kubernetes_cluster_region
  version = var.kubernetes_cluster_version

  dynamic "node_pool" {
    for_each = var.default_node_pools
    content {
      name       = node_pool.value.name
      size       = node_pool.value.size
      auto_scale = node_pool.value.auto_scale
      min_nodes  = node_pool.value.min_nodes
      max_nodes  = node_pool.value.max_nodes
    }
  }
}
