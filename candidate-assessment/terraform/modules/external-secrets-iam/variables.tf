variable "name" {
  description = "Resource name prefix."
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS IAM OIDC provider ARN."
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC issuer URL."
  type        = string
}

variable "database_secret_arn" {
  description = "Only Secrets Manager secret this role may read."
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}
