module "ecs-compute" {
  source  = "orchestra-hq/ecs-compute/aws"
  version = "0.0.3"

  name_prefix          = "awesome-compute"
  region               = "eu-west-2"
  integrations         = ["dbt_core", "python"]
  orchestra_account_id = "4a6a45ca-5549-4c53-bca4-43a76e1bab2c"

  task_secrets = [
    {
      # AWS Secrets Manager.
      name      = "API_KEY"
      valueFrom = "arn:aws:secretsmanager:ap-southeast-2:0123456789012:secret:test-api-key-1234"
    },
    {
      # AWS SSM parameter - the full ARN must be provided for this module.
      name      = "SSM_PARAMETER_DIFFERENT_REGION"
      valueFrom = "arn:aws:ssm:ap-southeast-2:123456789012:parameter/secret-param"
    }
  ]
}
