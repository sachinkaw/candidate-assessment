variable "name" {
  description = "Prefix used for names and tags."
  type        = string
  default     = "payment-processor"
}

variable "aws_region" {
  description = "AWS region for the platform."
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version supported in the selected region."
  type        = string
}

variable "postgres_engine_version" {
  description = "Supported PostgreSQL engine version for RDS."
  type        = string
}

variable "deploy_role_arn" {
  description = "Existing GitHub Actions OIDC role ARN granted cluster deployment access."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the platform VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "payments"
}

variable "database_username" {
  description = "Initial PostgreSQL master username."
  type        = string
  default     = "payments_admin"
}

variable "database_secret_name" {
  description = "Secrets Manager name consumed by External Secrets."
  type        = string
  default     = "payment-processor/database"
}

variable "database_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t4g.small"
}

variable "database_allocated_storage" {
  description = "RDS allocated storage in GiB."
  type        = number
  default     = 50
}

variable "database_max_allocated_storage" {
  description = "RDS autoscaling storage limit in GiB."
  type        = number
  default     = 200
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
