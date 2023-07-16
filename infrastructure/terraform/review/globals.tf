variable "target" {
  type        = string
  description = "The target to deploy"
}

variable "target_sha" {
  type = string
  description = "The target short sha to deploy"
}

variable "domain" {
  type        = string
  description = "The domain to use for the review apps"
}

variable "namepsace_admins" {
  type        = list(string)
  description = "The list of users that will be admin of the namespace"
  default     = []
}

variable "namepsace_editors" {
  type        = list(string)
  description = "The list of users that will be editor of the namespace"
  default     = []
}

variable "namepsace_readers" {
  type        = list(string)
  description = "The list of users that will be reader of the namespace"
  default     = []
}

locals {
  formated_target = replace(var.target, "/", "-")
}
