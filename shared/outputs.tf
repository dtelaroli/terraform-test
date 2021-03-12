output "vpc_private_subnets" {
  description = "VPC Private Subnets"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "VPC Public Subnets"
  value       = module.vpc.public_subnets
}
