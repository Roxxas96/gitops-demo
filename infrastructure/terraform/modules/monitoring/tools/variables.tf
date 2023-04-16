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
