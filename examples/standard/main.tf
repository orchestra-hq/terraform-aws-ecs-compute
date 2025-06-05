module "ecs-compute" {
  source = "orchestra-hq/ecs-compute/aws"

  name_prefix  = "awesome-compute"
  region       = "eu-west-2"
  integrations = ["dbt-core", "python"]
  tags = {
    Owner = "Awesome Team"
  }
  orchestra_account_id = "4a6a45ca-5549-4c53-bca4-43a76e1bab2c"
}
