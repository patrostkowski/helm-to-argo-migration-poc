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
    name      = "${var.env}-${var.name}"
    namespace = kubernetes_namespace.example_namespace.metadata.0.name
  }
}

#######################################
### GITOPS
#######################################

resource "gitops_checkout" "checkout" {}

resource "gitops_file" "file" {
  checkout = gitops_checkout.checkout.id
  path     = local.repo_file_path
  contents = local.internal_config
}

resource "gitops_commit" "commit" {
  commit_message = "Update ${basename(path.cwd)} values file in ${local.repo_file_path}."
  handles        = [gitops_file.file.id]
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

  depends_on = [gitops_commit.commit]
}
