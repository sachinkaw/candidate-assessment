output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC IPv4 CIDR."
  value       = aws_vpc.this.cidr_block
}

output "private_subnet_ids" {
  description = "Private subnet IDs, one per availability zone."
  value       = [for az in local.availability_zones : aws_subnet.private[az].id]
}

output "public_subnet_ids" {
  description = "Public subnet IDs, one per availability zone."
  value       = [for az in local.availability_zones : aws_subnet.public[az].id]
}
