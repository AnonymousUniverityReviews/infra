variable "role_name" {
  type    = string
  default = "default"
}

variable "name" {
  type    = string
  default = "default"
}

variable "runtime" {
  type    = string
  default = "python3.14"
}

variable "handler" {
  type    = string
  default = "main.lambda_handler"
}

variable "source_file" {
  type    = string
  default = "main.py"
}

