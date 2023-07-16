variable "environment" {
  type        = string
  description = "The environment of the cluster, ex: 'preprod', 'prod', 'local'"
}

variable "ingress-nginx-namespace" {
  type        = string
  description = "The namespace where the ingress-nginx release will be deployed"
  default     = null
}

variable "cert-manager-namespace" {
  type        = string
  description = "The namespace where the cert-manager release will be deployed"
  default     = null
}
