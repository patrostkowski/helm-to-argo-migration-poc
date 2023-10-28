module "dev" {
  source = "../../submodules/submodule-argo-v2"

  namespace = "dev"
  env       = "dev"
  name      = "postgres"
  project   = "example"

  sync_policy   = true
  custom_values = true
}
