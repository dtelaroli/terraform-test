output "vpc_private_subnets" {
  description = "VPC Private Subnets"
  value       = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "VPC Public Subnets"
  value       = module.vpc.public_subnets
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecs_cluster" {
  description = "ECS Cluster Data"
  value       = module.ecs
}

output "acm_certificate" {
  description = "ACM Certificate"
  value       = module.acm
}

output "public_alb" {
  description = "Public Application Load Balancer"
  value       = module.public_alb
}

output "cognito" {
  description = "Cognito User Pool"
  value       = module.public_alb
}

output "url" {
  description = "Url"
  value       = "http://${aws_route53_record.lb.fqdn}"
}

output "alb_security_group" {
  description = "ALB Security Group"
  value       = module.alb_https_sg
}
