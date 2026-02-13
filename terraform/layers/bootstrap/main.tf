resource "aws_s3_bucket" "backend_bucket" {
  bucket = "anonymous-university-reviews-backend-bucket"

  object_lock_enabled = true
}

module "gh_oidc" {
  source                    = "../../modules/gh_oidc"
  oidc_gha_role_policy_path = "../../policies/oidc_gha_role_policy.json"
  oidc_gha_role_path        = "../../policies/oidc_gha_role.json"
  gh_oidc_sub               = var.gh_oidc_sub
}

module "networking" {
  source   = "../../modules/network"
  name     = var.name
  tags     = var.tags
  vpc_cidr = var.vpc_cidr
}


resource "aws_ecr_repository" "frontend" {
  name                 = "frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name                 = "backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_secretsmanager_secret" "cloudflare_api_key" {
  name        = "cloudflare_api_key"
  description = "Cloudflare API key to be used by external-dns to update the DNS records"
}
