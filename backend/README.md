# Backend

Initial project for terraform backend. It belongs to only the shared environment.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Workspaces

- default

## Resources

| Name | Resource Name |
| ---- | --- |
| [aws_dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | ecs-test-backend-lock |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | ecs-test-backend-devops |
| [aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | Default region us-east-1 | string | us-east-1 | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | S3 Bucket for terraform states |
| dynamodb_table_name | DynamoDb table for terraform locks |

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
