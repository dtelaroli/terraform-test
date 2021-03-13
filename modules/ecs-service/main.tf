resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_name
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  task_role_arn      = var.role_arn
  execution_role_arn = var.role_arn

  container_definitions = jsonencode([
    {
      name         = var.name
      image        = var.image
      cpu          = var.cpu
      memory       = var.memory
      portMappings = var.port_mappings
      environment  = var.environment
      secrets      = var.secrets
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-stream-prefix = aws_cloudwatch_log_group.this.name
        }
      }
      essential = true
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name             = var.name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.this.arn
  platform_version = "1.4.0"

  desired_count = var.desired_count

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = 5

  network_configuration {
    security_groups = var.security_group_ids
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.name
    container_port   = var.container_port
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }

  tags = var.tags
}
