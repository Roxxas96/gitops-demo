variable "cluster_admins" {
  type        = list(string)
  description = "The users that will have cluster-admin privileges"
  default     = []
}

variable "cluster_managers" {
  type        = list(string)
  description = "The users that will have cluster-editor privileges"
  default     = []
}

variable "cluster_devs" {
  type        = list(string)
  description = "The users that will have cluster-reader privileges"
  default     = []
}

variable "enable_ingress" {
  type        = bool
  description = "Enable ingress controller & cert-manager"
  default     = true
}
