# Nginx App

Hello world Nginx App running in AWS ECS Fargate

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Workspaces

- stg
- prd

| Name                                                                                                    |
| ------------------------------------------------------------------------------------------------------- |
| [module.service](../../modules/ecs-service/README.md)                                                   |
| [module.ecs_sg](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)  |
| [module.iam_assumable_role](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest) |

## Variables

| Name   | Description              | Type   | Default   | Required |
| ------ | ------------------------ | ------ | --------- | :------: |
| region | Default region us-east-1 | string | us-east-1 |    no    |

## Outputs

| Name     | Description      |
| -------- | ---------------- |
| env_name | Environment name |

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
