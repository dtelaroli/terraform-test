module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "${local.project}-vpc"
  cidr = "10.200.0.0/16"

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "2.8.0"

  name = local.project

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [{ capacity_provider = "FARGATE" }]

  tags = local.tags
}
