variable "name" {
  description = "Database resource name prefix."
  type        = string
}

variable "postgres_engine_version" {
  description = "Supported RDS PostgreSQL engine version."
  type        = string
}

variable "database_name" {
  description = "Initial database name."
  type        = string
}

variable "database_username" {
  description = "Initial PostgreSQL master username."
  type        = string
}

variable "database_secret_name" {
  description = "Secrets Manager name consumed by External Secrets."
  type        = string
}

variable "database_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
}

variable "database_allocated_storage" {
  description = "RDS allocated storage in GiB."
  type        = number
}

variable "database_max_allocated_storage" {
  description = "RDS autoscaling storage limit in GiB."
  type        = number
}

variable "vpc_id" {
  description = "VPC ID containing the private database subnets."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the database subnet group."
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to PostgreSQL."
  type        = set(string)
}

variable "tags" {
  description = "Tags applied to database resources."
  type        = map(string)
  default     = {}
}
