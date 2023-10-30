#######################################
### SETUP
#######################################

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
    name      = local.common_name
    namespace = kubernetes_namespace.example_namespace.metadata.0.name
    labels = {
      "app.kubernetes.io/instance" = "${var.env}-${var.name}"
    }
  }
}

#######################################
### ARGO
#######################################


resource "argocd_project" "myproject" {
  metadata {
    name      = var.argocd_project_name
    namespace = "argocd"
  }

  spec {
    description = "simple project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.example_namespace.metadata.0.name
    }
  }
}

# Helm application
resource "argocd_application" "helm" {
  metadata {
    name      = local.common_name
    namespace = "argocd"
    labels    = local.app_labels
  }

  spec {
    project = argocd_project.myproject.metadata[0].name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.example_namespace.metadata.0.name
    }

    source {
      repo_url        = var.helm_repo_url
      chart           = var.helm_repo_chart_name
      target_revision = var.helm_chart_version
      helm {
        release_name = var.release_name
        values       = local.merged_config
      }
    }
  }
}
