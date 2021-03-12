data "aws_caller_identity" "current" {}

locals {
  region     = var.region
  account_id = data.aws_caller_identity.current.id
  env        = "shared"
  project    = "ecs-test-backend"

  bucket_name = "${local.project}-devops"

  tags = {
    Name        = local.project
    Environment = local.env
  }
}
