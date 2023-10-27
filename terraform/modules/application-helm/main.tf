provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-kind"
  }
}

resource "random_integer" "random" {
  min = 1
  max = 4
}

resource "null_resource" "this" {}

# Resource block to manage Kubernetes Namespace
resource "kubernetes_namespace" "example_namespace" {
  metadata {
    name = "example"
  }
}

# Helm release for Redis
resource "helm_release" "redis" {
  name       = "helm-postgres-${random_integer.random.result}"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = kubernetes_namespace.example_namespace.metadata.0.name

  set {
    name  = "auth.postgresPassword"
    value = "postgres"
  }
}
