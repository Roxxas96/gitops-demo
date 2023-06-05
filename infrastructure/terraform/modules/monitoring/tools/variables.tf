variable "environment" {
  type        = string
  description = "The environment of the cluster, ex: 'preprod', 'prod'"
}

variable "kube-prometheus-stack-namespace" {
  type        = string
  description = "The namespace of the kube-prometheus-stack"
}

variable "domain" {
  type        = string
  description = "The domain name of the monitoring tools"
}

variable "minimal_mode" {
  type        = bool
  description = "Enable minimal mode with disabled ingress, low or no persistence, etc. Designed for local development like k3d or minikube"
  default     = false
}
