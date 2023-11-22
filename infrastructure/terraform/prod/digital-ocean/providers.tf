terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.32.0"
    }
  }
  backend "http" {

  }
}

variable "digitalocean_token" {
  type        = string
  description = "Digital Ocean API token"
}

provider "digitalocean" {
  token = var.digitalocean_token
}
