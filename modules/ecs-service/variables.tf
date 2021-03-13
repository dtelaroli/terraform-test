variable "log_name" {
  description = "CloudWatch log group"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "name" {
  description = "Service and task name"
  type        = string
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  default     = 180
  type        = number
}

variable "desired_count" {
  description = "ECS task desired count"
  default     = 1
  type        = number
}

variable "image" {
  description = "Docker image url with tag"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster id"
  type        = string
}

variable "deployment_maximum_percent" {
  description = "Service deployment maximum percentege"
  default     = 200
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  description = "Service deployment minimum percentege"
  default     = 100
  type        = number
}

variable "container_port" {
  description = "Task container port"
  type        = number
}

variable "port_mappings" {
  description = "Task port mappings"
  type        = list(any)
}

variable "environment" {
  description = "Container environment variables"
  type        = list(any)
  default     = null
}

variable "secrets" {
  description = "Container secrets variables"
  type        = list(any)
  default     = null
}

variable "subnet_ids" {
  description = "VPC subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Load balancer target group ARN"
  type        = string
}

variable "security_group_ids" {
  description = "Load balancer security group IDs"
  type        = list(string)
}

variable "memory" {
  description = "Container memory reservation"
  type        = number
}

variable "cpu" {
  description = "Container cpu reservation"
  type        = number
}

variable "role_arn" {
  description = "Role ARN"
  type        = string
}

variable "tags" {
  description = "Billing tags"
  type        = map(string)
}
