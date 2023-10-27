module "prod" {
  source = "../../submodules/submodule-argo"

  // Pass file content to the module
  external_config = file("../../../helm/releases/postgres/prod-values.yaml")

  namespace = "prod"
  env       = "prod"
  name      = "postgres"
}
