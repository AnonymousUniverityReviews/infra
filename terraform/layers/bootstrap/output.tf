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
