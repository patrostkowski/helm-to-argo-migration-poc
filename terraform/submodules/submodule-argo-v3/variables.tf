variable "namespace" {
  type = string
}

variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "argocd_project_name" {
  type    = string
  default = "myproject"
}

variable "sync_policy" {
  type    = bool
  default = false
}

variable "project" {
  type = string
}

variable "external_config" {
  description = "External configuration in YAML format"
  type        = string
  default     = "{}"
}

variable "external_sops_config" {
  description = "External sops configuration in YAML format"
  type        = string
  default     = "{}"
}

variable "helm_repo_url" {
  type    = string
  default = "https://charts.bitnami.com/bitnami"
}

variable "helm_repo_chart_name" {
  type    = string
  default = "postgresql"
}

variable "helm_chart_version" {
  type    = string
  default = "13.1.5"
}

variable "release_name" {
  type = string
}
