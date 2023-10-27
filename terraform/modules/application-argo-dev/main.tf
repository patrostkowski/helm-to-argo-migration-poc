module "dev" {
  source = "../../submodules/submodule-argo"

  // Pass file content to the module
  external_config      = file("../../../helm/releases/postgres/dev-values.yaml")
  external_sops_config = file("../../../helm/releases/postgres/dev-values.secret.enc.yaml")

  namespace = "dev"
  env       = "dev"
  name      = "postgres"
}
