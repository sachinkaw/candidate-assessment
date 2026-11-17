variable "name" {
  description = "Prefix used for network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the VPC."
  type        = string
}

variable "availability_zone_count" {
  description = "Number of availability zones to use; must be at least two."
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 8
    error_message = "The network module requires between two and eight availability zones."
  }
}

variable "tags" {
  description = "Tags applied to network resources."
  type        = map(string)
  default     = {}
}
