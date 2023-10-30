locals {
  common_name = "${var.project}-${var.env}-${var.name}"

  internal_config = templatefile("${path.module}/internal/postgres.yaml", {
    service_account_name = kubernetes_service_account.example_service_account.metadata[0].name
    password             = random_password.password.result
  })

  merged_config = yamlencode(merge(
    yamldecode(local.internal_config),
    yamldecode(var.external_config),
    yamldecode(var.external_sops_config)
  ))

  app_labels = {
    "app.kubernetes.io/instance" = "${var.env}-${var.name}"
    "app.kubernetes.io/name"     = var.name
  }

  argo_labels = {
    "argocd.argoproj.io/instance"    = "${var.env}-${var.name}"
    "argocd.example.co/env"          = var.env
    "argocd.example.co/service-name" = var.name
  }
}


