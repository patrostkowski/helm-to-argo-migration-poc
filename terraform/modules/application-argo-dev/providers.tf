provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

provider "argocd" {
  insecure    = true
  server_addr = "localhost:8080"
  auth_token  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJ1c2VyOmFwaUtleSIsIm5iZiI6MTY5ODQ0MTMxMSwiaWF0IjoxNjk4NDQxMzExLCJqdGkiOiJ1c2VyIn0.L3y7zM05llL1WNQ3zj4mMeTGNJbizIAzFvkrybSIUlc"
}

provider "gitops" {
  repo_url = "https://github.com/patrostkowski/helm-to-argo-migration-poc.git"
  branch   = "@"
  path     = ".gitops"
}
