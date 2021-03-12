data "aws_caller_identity" "current" {}

locals {
  region    = var.region
  account_id = data.aws_caller_identity.current.id
  env       = "shared"
  project   = "ecs-test-shared"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.200.10.0/24", "10.200.11.0/24", "10.200.12.0/24"]
  public_subnets  = ["10.200.20.0/24", "10.200.21.0/24", "10.200.22.0/24"]

  tags = {
    Environment = local.env
    Project     = local.project
  }
}
