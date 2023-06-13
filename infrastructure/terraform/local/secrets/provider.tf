terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.14.0"
    }
  }
}

variable "vault_address" {
  type        = string
  description = "The address of the Vault server"
  default     = "http://localhost:8200"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "The token to authenticate to the Vault server"
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
