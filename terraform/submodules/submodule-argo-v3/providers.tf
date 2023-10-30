terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}
