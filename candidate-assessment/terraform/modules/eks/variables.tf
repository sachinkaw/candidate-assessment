variable "name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Supported EKS Kubernetes version."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the control plane and managed nodes."
  type        = list(string)
}

variable "deploy_role_arn" {
  description = "Existing deployment role to grant EKS cluster access."
  type        = string
}

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
  default     = {}
}
