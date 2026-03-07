output "private_subnets" {
  value = module.networking.private_subnets[*].id
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets" {
  value = module.networking.public_subnets[*].id
}

output "cloudflare_api_key_secret_arn" {
  value = aws_secretsmanager_secret.cloudflare_api_key.arn
}

output "cloudflare_api_key_secret_id" {
  value = aws_secretsmanager_secret.cloudflare_api_key.id
}

output "domain" {
  value = var.domain
}

output "domain_zone_id" {
  value     = data.cloudflare_zone.domain.zone_id
  sensitive = true
}

output "acm_certificate_validation_options" {
  value = aws_acm_certificate.cert.domain_validation_options
}
