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

variable "argocd_project_name" {
  type    = string
  default = "myproject"
}
