<!-- markdownlint-disable MD033 -->

# terraform-aws-ecs-compute

Deploy an AWS ECS cluster (with relevant resources) for a hybrid compute option with Orchestra.

## Contributing

When making contributions, ensure that pre-commit hooks are enabled, by running `pre-commit run -a`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.compute_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ecs_compute_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_task_definition.task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_compute_task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_task_get_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.role_assumed_from_orchestra_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.compute_execute_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_compute_task_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.role_assumed_from_orchestra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.compute_execute_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_compute_task_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_get_secrets_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.role_assumed_from_orchestra_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.orchestra_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.orchestra_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.artifact_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.secret_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.artifact_store_lifecycle_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.secret_store_lifecycle_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [random_id.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ecs_compute_task_role_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_get_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_assumed_from_orchestra_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_resources"></a> [compute\_resources](#input\_compute\_resources) | A map representing the compute resources (CPU and memory) to use for each integration. | <pre>map(object({<br/>    cpu    = number<br/>    memory = number<br/>  }))</pre> | <pre>{<br/>  "dbt_core": {<br/>    "cpu": 4096,<br/>    "memory": 8192<br/>  },<br/>  "python": {<br/>    "cpu": 2048,<br/>    "memory": 4096<br/>  }<br/>}</pre> | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Whether to enable Container Insights for the ECS cluster. Note: this will incur additional AWS charges. | `bool` | `false` | no |
| <a name="input_enhanced_container_insights"></a> [enhanced\_container\_insights](#input\_enhanced\_container\_insights) | Whether to use Enhanced Container Insights for the ECS cluster. Requires enable\_container\_insights to be true. Note: this will incur additional AWS charges. | `bool` | `false` | no |
| <a name="input_image_tags"></a> [image\_tags](#input\_image\_tags) | A map representing the ECR image tags to use for each integration. | `map(string)` | <pre>{<br/>  "dbt_core": "2026.1.7-1",<br/>  "python": "2026.1.7-1"<br/>}</pre> | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | n/a | `list` | <pre>[<br/>  "python",<br/>  "dbt_core"<br/>]</pre> | no |
| <a name="input_key_rotation_period_days"></a> [key\_rotation\_period\_days](#input\_key\_rotation\_period\_days) | The number of days to rotate the KMS key used to encrypt secrets. | `number` | `365` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | The number of days to retain CloudWatch logs produced by compute tasks. | `number` | `90` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix to use for the resources created by this module. | `string` | n/a | yes |
| <a name="input_orchestra_account_id"></a> [orchestra\_account\_id](#input\_orchestra\_account\_id) | Your Orchestra account ID, which can be found in the Account Settings page on Orchestra. | `string` | n/a | yes |
| <a name="input_orchestra_aws_account_id"></a> [orchestra\_aws\_account\_id](#input\_orchestra\_aws\_account\_id) | The Orchestra AWS account ID. Note: this is provided by default and does not need to be set manually. | `string` | `"355563318157"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden). | `map(string)` | `{}` | no |
| <a name="input_task_env_vars"></a> [task\_env\_vars](#input\_task\_env\_vars) | Environment variables to set on the ECS task when it runs. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_task_secrets"></a> [task\_secrets](#input\_task\_secrets) | Secrets to set on the ECS task when it runs. This will inject sensitive data into your containers as environment variables. The full ARNs of the secrets must be provided for this module. | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_store_bucket_id"></a> [artifact\_store\_bucket\_id](#output\_artifact\_store\_bucket\_id) | The name of the S3 bucket used to store artifacts generated during a compute task. |
| <a name="output_assumed_role_arn"></a> [assumed\_role\_arn](#output\_assumed\_role\_arn) | The ARN of the IAM role assumed by Orchestra to perform compute operations. |
| <a name="output_assumed_role_name"></a> [assumed\_role\_name](#output\_assumed\_role\_name) | The name of the IAM role assumed by Orchestra to perform compute operations. |
| <a name="output_compute_cluster_arn"></a> [compute\_cluster\_arn](#output\_compute\_cluster\_arn) | The ARN of the ECS cluster created by this module. |
| <a name="output_compute_cluster_name"></a> [compute\_cluster\_name](#output\_compute\_cluster\_name) | The name of the ECS cluster created by this module. |
| <a name="output_integration_task_role_arns"></a> [integration\_task\_role\_arns](#output\_integration\_task\_role\_arns) | The ARNs of the IAM roles created for each integration compute task. |
| <a name="output_integration_task_role_names"></a> [integration\_task\_role\_names](#output\_integration\_task\_role\_names) | The names of the IAM roles created for each integration compute task. |
| <a name="output_secret_store_bucket_id"></a> [secret\_store\_bucket\_id](#output\_secret\_store\_bucket\_id) | The name of the S3 bucket used to temporarily store secrets used during a compute task. |
<!-- END_TF_DOCS -->
