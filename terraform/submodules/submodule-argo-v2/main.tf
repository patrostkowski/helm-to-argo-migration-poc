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

resource "kubernetes_service_account" "example_service_account" {
  metadata {
    name      = "${var.env}-${var.name}"
    namespace = kubernetes_namespace.example_namespace.metadata.0.name
  }
}

resource "local_file" "values" {
  content  = local.internal_config
  filename = local.local_file_path
}

# Helm application
resource "argocd_application" "helm" {
  metadata {
    name      = "${var.env}-${var.name}"
    namespace = "argocd"
    labels    = local.app_labels
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
        value_files = ["${var.env}-values.yaml", "${var.env}-values.secret.enc.yaml"]
      }
    }

    # source {
    #   repo_url        = "https://charts.bitnami.com/bitnami"
    #   chart           = "postgresql"
    #   target_revision = "13.1.5"
    #   path            = "terraform/modules/application-argo-dev"
    #   helm {
    #     release_name = "${var.env}-${var.name}"
    #     #values       = local.internal_config
    #     value_files = [local.local_file_path]
    #   }
    # }
  }
}
