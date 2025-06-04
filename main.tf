data "aws_caller_identity" "current" {}

locals {
  integrations = [for k in var.integrations : lower(k)]
  tags = merge(
    {
      Application = "Orchestra Technologies"
      DeployedBy  = "Terraform"
    },
    var.tags,
  )
}

resource "random_id" "random_suffix" {
  # Produces an 8 character hex string.
  byte_length = 4
}
