locals {
  internal_config = templatefile("${path.module}/internal/postgres.yaml", {
    service_account_name = kubernetes_service_account.example_service_account.metadata[0].name
    password             = random_password.password.result
  })

  labels = {
    "argocd.argoproj.io/instance"    = "${var.env}-${var.name}"
    "argocd.example.co/env"          = var.env
    "argocd.example.co/service-name" = var.name
  }
}


