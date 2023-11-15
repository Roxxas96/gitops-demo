terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.32.0"
    }
  }
}

variable "digitalocean_token" {
  type        = string
  description = "Digital Ocean API token"
}

variable "spaces_credentials" {
  type = object({
    secret_key = string
    key_id     = string
  })
  description = "Digital Ocean Spaces secret key"
}

provider "digitalocean" {
  token             = var.digitalocean_token
  spaces_secret_key = var.spaces_credentials.secret_key
  spaces_access_id  = var.spaces_credentials.key_id
}
