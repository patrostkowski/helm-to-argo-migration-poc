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
    name      = "${var.env}-${var.name}"
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
      repo_url        = "https://github.com/patrostkowski/helm-to-argo-migration-poc.git"
      target_revision = var.repo_target_revision
      ref             = "root"
    }
    source {
      repo_url        = "https://charts.bitnami.com/bitnami"
      chart           = "postgresql"
      target_revision = "13.1.5"
      helm {
        release_name = "${var.env}-${var.name}"
        value_files = concat([
          "$root/terraform/modules/${basename(path.cwd)}/${local.local_file_path}",
          "$root/helm/releases/postgres/${var.env}-values.yaml",
          ],
          (var.sops ? ["$root/helm/releases/postgres/${var.env}-values.secret.enc.yaml"] : [])
        )
      }
    }
    sync_policy {
      automated {
        prune       = false
        self_heal   = var.sync_policy
        allow_empty = var.sync_policy
      }
    }
  }
}
