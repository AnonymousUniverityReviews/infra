variable "tags" {
  type = map(string)
  default = {
    "clusterName" : "ecs",
    "version" : "v1"
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
