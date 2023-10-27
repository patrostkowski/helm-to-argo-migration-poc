locals {
  internal_config = templatefile("${path.module}/internal/postgres.yaml", {
    service_account_name = "sa-pg-${random_integer.random.result}"
    password             = random_password.password.result
  })

  # values = var.external_config != "" ? yamlencode(
  #   merge(
  #     yamldecode(local.internal_config),
  #     yamldecode(var.external_config)
  # )) : local.internal_config

  values = var.external_config != "" ? (
    var.external_sops_config != "" ? yamlencode(
      merge(
        yamldecode(local.internal_config),
        yamldecode(var.external_sops_config),
        yamldecode(var.external_config)
      )
      ) : yamlencode(
      merge(
        yamldecode(local.internal_config),
        yamldecode(var.external_config)
      )
    )
  ) : local.internal_config
}


