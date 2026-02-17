variable "tags" {
  type = map(string)
  default = {
    "clusterName" : "eks",
    "version" : "v1"
  }
}

variable "name" {
  type    = string
  default = "default"
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

variable "db_config" {
  type = map(any)
  default = {
    studentus_db = {
      name = "studentus_db"
    },
    backend_data_protection_db = {
      name = "backend_data_protection_db"
    }
  }
}
