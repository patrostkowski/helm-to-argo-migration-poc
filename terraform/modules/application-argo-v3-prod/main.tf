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
  release_name         = "example-prod-v2-postgres-prod-v2"
  external_config      = data.local_file.values.content
  external_sops_config = data.local_file.sops.content

  helm_chart_version   = "13.1.5"
  helm_repo_chart_name = "postgresql"
  helm_repo_url        = "https://charts.bitnami.com/bitnami"
}

data "local_file" "my_postgres" {
  filename = "../../../helm/releases/postgres/my-postgres-values.yaml"
  #filename = "./assets/prod-values.secret.enc.yaml"
}

module "prod_v3_my_postgres" {
  source = "../../submodules/submodule-argo-v3"

  namespace           = "proj"
  env                 = "proj"
  name                = "my-postgres"
  argocd_project_name = "example"
  project             = "example"
  sync_policy         = false
  release_name        = "my-postgres"
  external_config     = data.local_file.my_postgres.content

  helm_chart_version   = "13.1.5"
  helm_repo_chart_name = "postgresql"
  helm_repo_url        = "https://charts.bitnami.com/bitnami"
}
