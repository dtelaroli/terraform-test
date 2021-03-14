# Shared Resources

Initial project for terraform shared resources. It belongs to only the shared environment.

## AWS credentials

Use [aws-vault](https://github.com/99designs/aws-vault) to manage your credentials or another of your preference.

## Workspaces

- default

## Resources

| Name                                                                                                                         |
| ---------------------------------------------------------------------------------------------------------------------------- |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition)   |
| [aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)                   |

## Variables

| Name                               | Description                           | Type         |  Default  | Required |
| ---------------------------------- | ------------------------------------- | ------------ | :-------: | :------: |
| region                             | AWS Region                            | string       | us-east-1 |    no    |
| log_name                           | CloudWatch log group                  | string       |     -     |   yes    |
| name                               | Service and task name                 | string       |     -     |   yes    |
| log_retention_in_days              | CloudWatch log retention in days      | number       |    180    |    no    |
| desired_count                      | ECS task desired count                | number       |     1     |    no    |
| image                              | Docker image url with tag             | string       |     -     |   yes    |
| cluster_id                         | ECS cluster id                        | string       |     -     |   yes    |
| deployment_minimum_healthy_percent | Service deployment minimum percentege | number       |    100    |    no    |
| deployment_maximum_percent         | Service deployment maximum percentege | number       |    200    |    no    |
| container_port                     | Task container port                   | number       |     -     |   yes    |
| port_mappings                      | Task port mappings                    | list(any)    |     -     |   yes    |
| environment                        | Container environment variables       | list(any)    |   null    |    no    |
| secrets                            | Container secrets variables           | list(any)    |   null    |    no    |
| subnet_ids                         | VPC subnet IDs                        | list(string) |     -     |   yes    |
| target_group_arn                   | Load balancer target group ARN        | string       |     -     |   yes    |
| security_group_ids                 | Load balancer security group IDs      | list(string) |     -     |   yes    |
| memory                             | Container memory reservation          | number       |     -     |   yes    |
| cpu                                | Container cpu reservation             | number       |     -     |   yes    |
| role_arn                           | Role ARN                              | string       |     -     |   yes    |
| tags                               | Billing tags                          | map(string)  |     -     |   yes    |

## Outputs

| Name            | Description     |
| --------------- | --------------- |
| task_definition | Task Definition |

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
