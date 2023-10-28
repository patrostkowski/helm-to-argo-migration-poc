module "prod" {
  source = "../../submodules/submodule-argo-v2"

  namespace           = "prod"
  env                 = "prod"
  name                = "postgres"
  argocd_project_name = "prod-postgres"

  repo_target_revision = "main"
  custom_values        = true
}
