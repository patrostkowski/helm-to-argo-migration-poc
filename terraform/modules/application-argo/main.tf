module "example" {
  source = "../../submodules/submodule-argo"

  // Pass file content to the module
  external_config = file("${path.module}/assets/postgres.yaml")
}
