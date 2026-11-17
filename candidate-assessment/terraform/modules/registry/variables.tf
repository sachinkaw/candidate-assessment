variable "name" {
  description = "ECR repository name."
  type        = string
}

variable "tags" {
  description = "Tags applied to registry resources."
  type        = map(string)
  default     = {}
}
