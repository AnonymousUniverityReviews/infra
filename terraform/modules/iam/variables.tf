variable "tags" {
  type = map(string)
  default = {
    "project" : "studentus"
  }
}

variable "name" {
  type    = string
  default = "studentus"
}
