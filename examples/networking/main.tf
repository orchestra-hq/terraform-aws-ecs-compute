terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "ecs-compute" {
  source = "orchestra-hq/ecs-compute/aws"

  name_prefix  = var.name_prefix
  region       = var.region
  integrations = ["dbt_core", "python"]
  tags = {
    Environment = "Demo"
  }

  orchestra_account_id = var.orchestra_account_id
}
