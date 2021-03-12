terraform {
  required_version = "0.14.8"

  required_providers {
    aws = {
      version = "3.31.0"
      source  = "hashicorp/aws"
    }
  }
}
