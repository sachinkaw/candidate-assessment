variable "aws_region" {
  description = "AWS region for the production platform."
  type        = string
  default     = "us-east-1"
}

variable "kubernetes_version" {
  description = "Supported EKS Kubernetes version."
  type        = string
  default     = "1.33"
}

variable "postgres_engine_version" {
  description = "Supported RDS PostgreSQL 16 minor version."
  type        = string
  default     = "16.8"
}

variable "deploy_role_arn" {
  description = "Existing GitHub Actions OIDC role ARN."
  type        = string
}
