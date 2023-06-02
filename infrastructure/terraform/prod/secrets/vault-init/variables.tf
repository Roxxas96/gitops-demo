variable "domain" {
  type        = string
  description = "The domain name for vault"
  default     = "192.168.10.10.sslip.io"
}

variable "enable_ingress" {
  type        = bool
  description = "Enable ingress resources for vault"
  default     = true
}
