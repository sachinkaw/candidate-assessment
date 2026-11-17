output "endpoint" {
  description = "Private RDS PostgreSQL endpoint."
  value       = aws_db_instance.this.address
}

output "secret_name" {
  description = "Secrets Manager secret name."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_arn" {
  description = "Secrets Manager secret ARN for policy scoping."
  value       = aws_secretsmanager_secret.this.arn
}
