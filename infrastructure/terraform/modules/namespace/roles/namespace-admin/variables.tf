variable "namespace" {
  type        = string
  description = "The namespace to create the role in"
}

variable "users" {
  type        = list(string)
  description = "The users to bind to the role"
  default     = []
}
