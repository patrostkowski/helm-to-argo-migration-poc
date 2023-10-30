module "prod_v3" {
  source = "../../submodules/submodule-argo-v3"

  namespace           = "prod-v2"
  env                 = "prod-v2"
  name                = "postgres-prod-v2"
  argocd_project_name = "prod-v2-postgres"
  project             = "example"
  sync_policy         = false
}
