terraform {
  backend "s3" {
    bucket       = "anonymous-university-reviews-backend-bucket"
    key          = "terraform-bootstrap.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}
