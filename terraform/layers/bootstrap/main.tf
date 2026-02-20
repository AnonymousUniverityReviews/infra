resource "aws_s3_bucket" "backend_bucket" {
  bucket = "anonymous-university-reviews-backend-bucket"

  object_lock_enabled = true
}

resource "aws_s3_bucket" "migration_bucket" {
  bucket = "anonymous-university-migration-bucket"
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

resource "aws_secretsmanager_secret" "backend_email_hash_key" {
  name        = "backend/EmailSecrets/EmailHashKey"
  description = "Backend email hash key"
}

resource "aws_secretsmanager_secret" "backend_email_verification_token_hash_key" {
  name        = "backend/EmailSecrets/EmailVerificationTokenHashKey"
  description = "Backend email verification token hash key"
}

resource "aws_secretsmanager_secret" "backend_resend_key" {
  name        = "backend/ResendKey"
  description = "Backend resend key"
}

resource "aws_secretsmanager_secret" "frontend_secrets" {
  name        = "frontend/secrets"
  description = "Frontend secrets"
}

resource "aws_secretsmanager_secret_version" "frontend_secrets" {
  secret_id = aws_secretsmanager_secret.frontend_secrets.id
  secret_string = jsonencode({
    "NUXT_OIDC_PROVIDERS_OIDC_CLIENT_SECRET" : "",
    "NUXT_OIDC_TOKEN_KEY" : "",
    "NUXT_OIDC_SESSION_SECRET" : "",
    "NUXT_OIDC_AUTH_SESSION_SECRET" : ""
  })
}

resource "aws_secretsmanager_secret" "main_database" {
  name        = "backend/DatabaseConnections/MainDatabase"
  description = "Main Database connection secrets"
}

resource "aws_secretsmanager_secret_version" "main_database" {
  secret_id = aws_secretsmanager_secret.main_database.id
  secret_string = jsonencode({
    "DatabaseConnections__MainDatabase__Host" : "",
    "DatabaseConnections__MainDatabase__Port" : "",
    "DatabaseConnections__MainDatabase__Database" : "",
    "DatabaseConnections__MainDatabase__Username" : "",
    "DatabaseConnections__MainDatabase__Password" : ""
  })
}

resource "aws_secretsmanager_secret" "data_protection_database" {
  name        = "backend/DatabaseConnections/DataProtectionDatabase"
  description = "Data Protection Database connection secrets"
}

resource "aws_secretsmanager_secret_version" "data_protection_database" {
  secret_id = aws_secretsmanager_secret.data_protection_database.id
  secret_string = jsonencode({
    "DatabaseConnections__DataProtectionDatabase__Host" : "",
    "DatabaseConnections__DataProtectionDatabase__Port" : "",
    "DatabaseConnections__DataProtectionDatabase__Database" : "",
    "DatabaseConnections__DataProtectionDatabase__Username" : "",
    "DatabaseConnections__DataProtectionDatabase__Password" : ""
  })
}

resource "aws_secretsmanager_secret" "openiddict_certificates_meta" {
  name        = "backend/OpenIdDictCertificatesMeta"
  description = "OpenIdDict certificates secrets"
}

resource "aws_secretsmanager_secret_version" "openiddict_certificates_meta" {
  secret_id = aws_secretsmanager_secret.openiddict_certificates_meta.id
  secret_string = jsonencode({
    "OPENIDDICT_ENCRYPTION_CERTIFICATE_FILE_CONTAINER_PATH" : "",
    "OPENIDDICT_SIGNING_CERTIFICATE_FILE_CONTAINER_PATH" : "",
    "OPENIDDICT_ENCRYPTION_CERTIFICATE_PASSWORD" : "",
    "OPENIDDICT_SIGNING_CERTIFICATE_PASSWORD" : ""
  })
}

resource "aws_secretsmanager_secret" "openiddict_certificates" {
  name        = "backend/OpenIdDictCertificates"
  description = "OpenIdDict certificates secrets"
}

resource "aws_secretsmanager_secret_version" "openiddict_certificates" {
  secret_id = aws_secretsmanager_secret.openiddict_certificates.id
  secret_string = jsonencode({
    "server-encryption-certificate" : "",
    "server-signing-certificate" : ""
  })
}

# module "vpn" {
#   source = "../../modules/vpn"

#   organization_name   = "Anonymous University Reviews"
#   country             = "UA"
#   vpn_domain          = "vpn.${var.domain}"
#   vpc_id              = module.networking.vpc_id
#   subnet_ids          = module.networking.private_subnet_ids
#   target_network_cidr = module.networking.vpc_cidr
#   tags                = var.tags
# }
