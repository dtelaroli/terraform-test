provider "aws" {
  region = local.region
}

terraform {
  backend "s3" {
    bucket         = "ecs-test-backend-devops"
    key            = "shared/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ecs-test-backend-lock"
  }
}
