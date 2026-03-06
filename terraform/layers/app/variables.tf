variable "name" {
  type    = string
  default = "studentus"
}

variable "region" {
  default = "eu-central-1"
}

variable "tags" {
  type = map(string)
  default = {
    "version" : "v1",
    "project" : "studentus"
  }
}

variable "domain_name" {
  type        = string
  description = "The domain name for the frontend application (e.g., studentus.tech)"
  default     = "studentus.tech"
}
