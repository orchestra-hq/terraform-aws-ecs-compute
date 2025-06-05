module "ecs-compute" {
  source  = "orchestra-hq/ecs-compute/aws"
  version = "0.0.3"

  name_prefix          = "awesome-compute"
  region               = "eu-west-2"
  integrations         = ["dbt-core", "python"]
  orchestra_account_id = "4a6a45ca-5549-4c53-bca4-43a76e1bab2c"

  task_secrets = [
    {
      # AWS Secrets Manager.
      name      = "API_KEY"
      valueFrom = "arn:aws:secretsmanager:ap-southeast-2:0123456789012:secret:test-api-key-1234"
    },
    {
      # You can also use AWS SSM parameters as secrets. If the parameter is in the same region as the ECS task, you only require the name.
      name      = "SSM_PARAMETER_SAME_REGION"
      valueFrom = "secret-param"
    },
    {
      # If the AWS SSM parameter is in a different region to the ECS task, you need to provide the full ARN.
      name      = "SSM_PARAMETER_DIFFERENT_REGION"
      valueFrom = "arn:aws:ssm:ap-southeast-2:123456789012:parameter/secret-param"
    }
  ]
}
