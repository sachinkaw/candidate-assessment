output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Private EKS API endpoint."
  value       = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
  description = "ECR repository URL for the application image."
  value       = module.registry.repository_url
}

output "external_secrets_role_arn" {
  description = "IRSA role ARN for the External Secrets controller."
  value       = module.external_secrets_iam.role_arn
}

output "database_secret_name" {
  description = "Secrets Manager name holding the database credentials."
  value       = module.database.secret_name
}

output "database_endpoint" {
  description = "Private RDS endpoint."
  value       = module.database.endpoint
}

output "aws_region" {
  description = "AWS region where the platform is deployed."
  value       = var.aws_region
}
