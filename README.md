# Terraform Test

POC Project with Terraform IaC. It includes a ECS service running Nginx container and Cognito Authorization.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Resources

| Name                                     | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| [backend](./backend/README.md)           | resources to configure terraform S3 remote state and lock table |
| [shared](./shared/README.md)             | shared resources used by applications                           |
| [modules](./modules/README.md)           | resources to configure terraform S3 remote state and lock table |
| [applications](./applications/README.md) | resources to configure terraform S3 remote state and lock table |

## Requirements

- [terraform cli](https://www.terraform.io/docs/cli/index.html) ([tfswitch](https://tfswitch.warrensbox.com) it's a good option)
- [go](https://golang.org)

## Deployment

There is a order to apply all resources:

1. backend
1. shared
1. applications

```
aws-vault exec <your-profile> -d 12h --

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
terraform workspace new stg
terraform workspace new prd
terraform plan -out plan.apply
terraform apply plan.apply

cd -
```

## Testing

There is a basic test in test folder.

### Running tests

```
aws-vault exec <your-profile> -d 12h --

cd test
go test

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
terraform plan -out plan.destroy -destroy
terraform apply plan.destroy

cd -
cd shared
terraform init
terraform plan -out plan.destroy -destroy
terraform apply plan.destroy

cd -
cd backend
terraform init
terraform plan -out plan.destroy -destroy
terraform apply plan.destroy

cd -
```

## Roadmap

- Add [moto](https://github.com/gruntwork-io/terratest/tree/master/test-docker-images/moto) for mocked tests
- 