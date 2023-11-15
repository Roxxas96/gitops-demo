terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.14.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }

  backend "s3" {

  }
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig file"
  default     = "~/.kube/gitops-demo-prod.kubeconfig"
}

variable "kubeconfig_context" {
  type        = string
  description = "Context to use in kubeconfig"
  default     = "default"
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

provider "kubectl" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}

variable "vault_address" {
  type        = string
  description = "The address of the Vault server"
  default     = "https://vault.192.168.10.10.sslip.io"
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
