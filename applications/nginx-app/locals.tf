data "aws_caller_identity" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    region         = var.region
    bucket         = "ecs-test-backend-devops"
    key            = "shared/terraform.tfstate"
    dynamodb_table = "ecs-test-backend-lock"
  }
}

locals {
  context = {
    stg = {
      name = "staging"
    }
    prd = {
      name = "production"
    }
  }
  env        = terraform.workspace
  env_name   = local.context[terraform.workspace].name
  region     = var.region
  account_id = data.aws_caller_identity.current.id
  project    = "ecs-test-nginx-app"

  vpc_id                = data.terraform_remote_state.shared.outputs.vpc_id
  private_subnet_ids    = data.terraform_remote_state.shared.outputs.vpc_private_subnets
  target_group_arn      = data.terraform_remote_state.shared.outputs.public_alb.target_group_arns[0]
  cluster_id            = data.terraform_remote_state.shared.outputs.ecs_cluster.this_ecs_cluster_id
  alb_security_group_id = data.terraform_remote_state.shared.outputs.alb_security_group.this_security_group_id
  container_port        = 80
  cpu                   = 512
  memory                = 1024
  desired_count         = 1
  docker_image          = "nginx"

  tags = {
    Name        = local.project
    Environment = local.env
  }
}
