output "vpc_id" {
  description = "The unique identifier of the created VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "List of public subnet IDs"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}
