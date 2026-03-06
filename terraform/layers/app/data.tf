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

data "aws_secretsmanager_secret" "cloudflare_api_key" {
  name = "cloudflare_api_key"
}

data "aws_secretsmanager_secret_version" "cloudflare_api_key_version" {
  secret_id = data.aws_secretsmanager_secret.cloudflare_api_key.id
}

data "cloudflare_zone" "domain" {
  filter = {
    name = var.domain_name
  }
}
