variable "gh_oidc_sub" {
  type    = string
  default = "repo:StudentusReviews/*:*"
}

variable "region" {
  default = "eu-central-1"
}

variable "name" {
  type    = string
  default = "default"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    "clusterName" : "ecs",
    "version" : "v1"
  }
}

variable "domain" {
  type    = string
  default = "studentus.tech"
}
