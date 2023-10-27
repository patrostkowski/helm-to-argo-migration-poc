resource "random_integer" "random" {
  min = 1
  max = 4
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "null_resource" "this" {}

# Resource block to manage Kubernetes Namespace
resource "kubernetes_namespace" "example_namespace" {
  metadata {
    name = "example-2"
  }
}

# Helm application
resource "argocd_application" "helm" {
  metadata {
    name      = "helm-postgres-${random_integer.random.result}"
    namespace = "argocd"
    labels = {
      test = "true"
    }
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.example_namespace.metadata.0.name
    }

    source {
      repo_url        = "https://charts.bitnami.com/bitnami"
      chart           = "postgresql"
      target_revision = "13.1.5"
      helm {
        release_name = "helm-postgres-${random_integer.random.result}"
        values       = local.values
      }
    }

    source {
      repo_url        = "https://github.com/patrostkowski/helm-to-argo-migration-poc"
      target_revision = "master"
      path            = "terraform/modules/application-argo/assets"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }
}
