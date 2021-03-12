data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name = "dev.toloja.com.br"
}

locals {
  region     = var.region
  account_id = data.aws_caller_identity.current.id
  env        = "shared"
  project    = "ecs-test-shared"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.200.10.0/24", "10.200.11.0/24", "10.200.12.0/24"]
  public_subnets  = ["10.200.20.0/24", "10.200.21.0/24", "10.200.22.0/24"]
  domain_name     = data.aws_route53_zone.this.name
  r53_zone_id     = data.aws_route53_zone.this.zone_id

  tags = {
    Name        = local.project
    Environment = local.env
  }
}
