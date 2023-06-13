variable "environment" {
  type        = string
  description = "The environment of the cluster, ex: 'preprod', 'prod', 'local'"
}

variable "namespace" {
  type        = string
  description = "The namespace where the monitoring tools will be deployed"
}

variable "domain" {
  type        = string
  description = "The domain name of the monitoring tools"
  default     = null
}
