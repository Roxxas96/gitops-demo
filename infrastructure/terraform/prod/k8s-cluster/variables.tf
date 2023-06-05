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

variable "minimal_mode" {
  type        = bool
  description = "Enable minimal mode with disabled ingress, low or no persistence, etc. Designed for local development like k3d or minikube"
  default     = false
}
