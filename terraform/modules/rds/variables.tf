variable "subnets" {
  type        = list(string)
  description = "list of subnets"
}

variable "name" {
  type        = string
  description = "database and subnet group name"
}