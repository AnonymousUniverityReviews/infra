data "aws_secretsmanager_secret_version" "cloudflare_api_key_version" {
  secret_id = aws_secretsmanager_secret.cloudflare_api_key.id
}

data "cloudflare_zone" "domain" {
  filter = {
    name = var.domain
  }
}
