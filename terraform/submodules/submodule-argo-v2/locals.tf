locals {
  internal_config = templatefile("${path.module}/internal/postgres.yaml", {
    service_account_name = kubernetes_service_account.example_service_account.metadata[0].name
    password             = random_password.password.result
  })

  app_labels = {
    "app.kubernetes.io/instance" = "${var.env}-${var.name}"
    "app.kubernetes.io/name"     = var.name
  }

  argo_labels = {
    "argocd.argoproj.io/instance"    = "${var.env}-${var.name}"
    "argocd.example.co/env"          = var.env
    "argocd.example.co/service-name" = var.name
  }

  local_file_path = "assets/values/${var.env}-values.internal.yaml"
}


