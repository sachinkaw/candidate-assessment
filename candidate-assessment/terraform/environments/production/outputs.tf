output "cluster_name" {
  value = module.payment_platform.cluster_name
}

output "ecr_repository_url" {
  value = module.payment_platform.ecr_repository_url
}

output "external_secrets_role_arn" {
  value = module.payment_platform.external_secrets_role_arn
}

output "database_secret_name" {
  value = module.payment_platform.database_secret_name
}

output "database_endpoint" {
  value = module.payment_platform.database_endpoint
}

output "aws_region" {
  value = module.payment_platform.aws_region
}
