variable "environment" {
  type        = string
  description = "The environment of the cluster, ex: 'preprod', 'prod', 'local'"
}

variable "words-namespace" {
  type        = string
  description = "The namespace of the word apps"
}
