variable "external_config" {
  description = "Content of the external configuration"
  type        = string
  default     = ""
}

variable "external_sops_config" {
  description = "Content of the external configuration"
  type        = string
  default     = ""
}

variable "namespace" {
  type = string
}

variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "sops" {
  type    = bool
  default = false
}

variable "custom_values" {
  type    = bool
  default = false
}

variable "argocd_project_name" {
  type    = string
  default = "myproject"
}

variable "repo_target_revision" {
  type    = string
  default = "main"
}

variable "repo_git_url" {
  type    = string
  default = "https://github.com/patrostkowski/helm-to-argo-migration-poc.git"
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_chart_name" {
  type    = string
  default = "postgres"
}

variable "helm_chart_version" {
  type    = string
  default = "13.1.5"
}

variable "sync_policy" {
  type    = bool
  default = false
}

variable "project" {
  type = string
}
