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
    name = var.namespace
  }
}

# Helm application
resource "argocd_application" "helm" {
  metadata {
    name      = "${var.env}-${var.name}"
    namespace = "argocd"
    labels = {
      app = "${var.env}-${var.name}"
    }
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.example_namespace.metadata.0.name
    }

    source {
      repo_url        = "https://github.com/patrostkowski/helm-to-argo-migration-poc.git"
      target_revision = "main"
      ref             = "values"
      path            = "helm/releases/${var.name}"
      helm {
        value_files = ["dev-values.yaml", "dev-values.secret.enc.yaml"]
      }
    }

    # source {
    #   repo_url        = "https://charts.bitnami.com/bitnami"
    #   chart           = "postgresql"
    #   target_revision = "13.1.5"
    #   helm {
    #     release_name = "${var.env}-${var.name}"
    #     value_files = [
    #       "helm/releases/${var.name}/dev-values.yaml"
    #     ]
    #   }
    # }
  }
}
