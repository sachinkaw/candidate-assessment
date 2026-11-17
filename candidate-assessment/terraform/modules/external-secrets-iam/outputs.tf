output "role_arn" {
  description = "IRSA role ARN for External Secrets."
  value       = aws_iam_role.this.arn
}
