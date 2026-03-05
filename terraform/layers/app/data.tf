data "terraform_remote_state" "ops" {
  backend = "s3"
  config = {
    bucket = "anonymous-university-reviews-backend-bucket"
    key    = "terraform-ops.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "anonymous-university-reviews-backend-bucket"
    key    = "terraform-bootstrap.tfstate"
    region = "eu-central-1"
  }
}
