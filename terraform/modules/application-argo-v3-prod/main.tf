data "local_file" "values" {
  filename = "../../../helm/releases/postgres/prod-values.yaml"
  #filename = "./assets/prod-values.yaml"
}

data "local_file" "sops" {
  filename = "../../../helm/releases/postgres/prod-values.secret.enc.yaml"
  #filename = "./assets/prod-values.secret.enc.yaml"
}

module "prod_v3" {
  source = "../../submodules/submodule-argo-v3"

  namespace            = "prod-v2"
  env                  = "prod-v2"
  name                 = "postgres-prod-v2"
  argocd_project_name  = "prod-v2-postgres"
  project              = "example"
  sync_policy          = false
  external_config      = data.local_file.values.content
  external_sops_config = data.local_file.sops.content
}
