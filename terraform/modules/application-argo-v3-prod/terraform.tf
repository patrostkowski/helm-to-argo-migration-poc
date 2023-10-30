terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }
    gitops = {
      source  = "tyler-technologies/gitops"
      version = "0.0.3-rc"
    }
  }
}
