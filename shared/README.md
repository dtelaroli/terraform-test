# Shared Resources

Initial project for terraform shared resources. It belongs to only the shared environment.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Workspaces

- default

## Resources

| Name                                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------------- |
| [module.vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)                                |
| [module.ecs](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest)                                |
| [module.public_alb](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)                         |
| [module.acm](https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/latest)                                |
| [module.alb_http_sg](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)             |
| [module.alb_https_sg](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)            |
| [module.cognito](https://registry.terraform.io/modules/mineiros-io/cognito-user-pool/aws/latest/examples/complete)      |
| [module.aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |

## Variables

| Name   | Description              | Type   | Default   | Required |
| ------ | ------------------------ | ------ | --------- | :------: |
| region | Default region us-east-1 | string | us-east-1 |    no    |

## Outputs

| Name                | Description                      |
| ------------------- | -------------------------------- |
| vpc_id              | VPC ID                           |
| vpc_private_subnets | VPC Private Subnet IDs           |
| vpc_public_subnets  | VPC Public Subnet IDs            |
| ecs_cluster         | ECS Cluster data                 |
| acm_certificate     | ACM Certificate                  |
| public_alb          | Public Application Load Balancer |
| cognito             | Cognito User Pool                |
| ecs_cluster         | ECS Cluster data                 |
| alb_security_group  | ALB Security Group               |
| url                 | Load Balancer URL                |

## Deploy

```
terraform init
terraform plan -out plan.apply
terraform apply plan.apply
```

## Clean Up

```
terraform destroy
```
