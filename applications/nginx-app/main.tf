module "service" {
  source             = "../../modules/ecs-service"
  name               = "${local.project}-${local.env}"
  log_name           = "/aws/ecs/${local.project}-${local.env}"
  desired_count      = local.desired_count
  cluster_id         = local.cluster_id
  region             = local.region
  image              = local.docker_image
  container_port     = local.container_port
  cpu                = local.cpu
  memory             = local.memory
  security_group_ids = [module.ecs_sg.this_security_group_id]
  subnet_ids         = local.private_subnet_ids
  target_group_arn   = local.target_group_arn
  role_arn           = module.iam_assumable_role.this_iam_role_arn
  port_mappings = [
    {
      containerPort = local.container_port
      hostPort      = local.container_port
      protocol      = "tcp"
    }
  ]

  tags = local.tags
}

module "ecs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name        = "${local.project}-${local.env}-ecs"
  vpc_id      = local.vpc_id
  description = "Security group with open port for ECS (${local.container_port}) from ALB, egress ports are all world open"

  ingress_with_source_security_group_id = [
    {
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "ECS container port"
      source_security_group_id = local.alb_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = local.tags
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "3.13.0"

  trusted_role_arns = [
    local.account_id
  ]

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  role_name         = "${local.project}-${local.env}-execution-role"
  create_role       = true
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  tags = local.tags
}
