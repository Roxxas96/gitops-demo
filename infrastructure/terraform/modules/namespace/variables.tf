variable "name" {
  type        = string
  description = "The name of the namespace"
}

variable "domain" {
  type        = string
  description = "The domain of the namespace, ex: 'app', 'monitoring', 'scurity'"
}

variable "additional_labels" {
  type        = map(string)
  description = "Additional labels to be added to the namespace"
  default     = {}
}

variable "quota" {
  type = object({
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
  })
  description = "The quota of the namespace"
  default     = null
}

variable "admins" {
  type        = list(string)
  description = "The list of users to be admins of the namespace"
  default     = []
}

variable "editors" {
  type        = list(string)
  description = "The list of users to be editors of the namespace"
  default     = []
}

variable "readers" {
  type        = list(string)
  description = "The list of users to be readers of the namespace"
  default     = []
}
