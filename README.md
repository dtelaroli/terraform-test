# Terraform Test

Project with a POC with Terraform IaC. It includes a ECS service running Nginx container and Cognito Authorization.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Resources

| Name                                     | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| [backend](./backend/README.md)           | resources to configure terraform S3 remote state and lock table |
| [shared](./shared/README.md)             | shared resources used by applications                           |
| [modules](./modules/README.md)           | resources to configure terraform S3 remote state and lock table |
| [applications](./applications/README.md) | resources to configure terraform S3 remote state and lock table |

## Deployment

There is a order to apply all resources:

1. backend
1. shared
1. applications

```
cd backend
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

cd -
cd shared
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

cd -
cd applications/nginx-app
terraform init
terraform plan -out plan.apply
terraform apply plan.apply

cd -
```

## Clean Up

There is a order to destroy all resources:

1. applications
1. shared
1. backend

```
cd applications/nginx-app
terraform init
terraform plan -out plan.destroy
terraform apply plan.destroy

cd -
cd shared
terraform init
terraform plan -out plan.destroy
terraform apply plan.destroy

cd -
cd backend
terraform init
terraform plan -out plan.destroy
terraform apply plan.destroy

cd -
```
