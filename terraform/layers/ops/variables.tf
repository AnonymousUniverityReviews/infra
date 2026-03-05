variable "tags" {
  type = map(string)
  default = {
    "version" : "v1",
    "project" : "studentus"
  }
}

variable "name" {
  type    = string
  default = "studentus"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "admin_user" {
  type    = string
  default = "ADMIN"
}

variable "github_actions_oidc_role_name" {
  default = "github_actions_oidc"
}
