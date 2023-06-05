variable "domain" {
  type        = string
  description = "The domain name of the monitoring tools"
  default     = "preprod.127.0.0.1.sslip.io"
}

variable "minimal_mode" {
  type        = bool
  description = "Enable minimal mode with disabled ingress, low or no persistence, etc. Designed for local development like k3d or minikube"
  default     = false
}
