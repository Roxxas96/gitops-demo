variable "domain" {
  type        = string
  description = "The domain name of the monitoring tools"
  default     = "preprod.127.0.0.1.sslip.io"
}

variable "enable_ingress" {
  type        = bool
  description = "Enable ingress controller & cert-manager"
  default     = true
}
