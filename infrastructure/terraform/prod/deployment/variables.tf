variable "domain" {
  type        = string
  description = "The domain name of the monitoring tools"
  default     = "192.168.10.10.sslip.io"
}

variable "enable_ingress" {
  type        = bool
  description = "Enable ingress resources for argo"
  default     = false
}
