variable "gh_oidc_sub" {
  type    = string
  default = "repo:StudentusReviews/*:*"
}

variable "region" {
  default = "eu-central-1"
}

variable "name" {
  type    = string
  default = "studentus"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    "version" : "v1",
    "project" : "studentus"
  }
}

variable "domain" {
  type    = string
  default = "studentus.tech"
}
