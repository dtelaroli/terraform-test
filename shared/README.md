# Shared Resources

Initial project for terraform shared resources. It belongs to only the shared environment.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Workspaces

- default

## Resources

| Name |
| ---- |
| [module.vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) |

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | Default region us-east-1 | string | us-east-1 | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_private_subnets | VPC Private Subnet IDs |
| vpc_public_subnets | VPC Public Subnet IDs |

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
