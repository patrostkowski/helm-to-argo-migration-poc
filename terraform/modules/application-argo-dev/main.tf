module "dev" {
  source = "../../submodules/submodule-argo"

  // Pass file content to the module
  external_config = file("../../../helm/releases/postgres/dev-values.yaml")

  namespace = "dev"
  env       = "dev"
  name      = "postgres"
}
