# The names asserted here are parsed and rebuilt by Orchestra's control plane.
# Changing any of them is a breaking change for existing deployments.

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  mock_resource "aws_ecs_cluster" {
    defaults = {
      arn = "arn:aws:ecs:eu-west-2:123456789012:cluster/awesome-compute-orchestra-compute-cluster-abcd1234"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::123456789012:role/mock"
    }
  }

  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/mock"
    }
  }

  mock_resource "aws_kms_key" {
    defaults = {
      arn = "arn:aws:kms:eu-west-2:123456789012:key/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "random" {
  mock_resource "random_id" {
    defaults = {
      hex = "abcd1234"
    }
  }
}

variables {
  name_prefix          = "awesome-compute"
  region               = "eu-west-2"
  orchestra_account_id = "4a6a45ca-5549-4c53-bca4-43a76e1bab2c"
}

run "python_and_dbt_core_render_the_version_package_manager_matrix" {
  variables {
    integrations = ["dbt_core", "python"]
  }

  assert {
    condition = toset(keys(aws_ecs_task_definition.task_definition)) == toset([
      "dbt_core_3_11_PIP",
      "dbt_core_3_11_POETRY",
      "dbt_core_3_11_UV",
      "dbt_core_3_12_PIP",
      "dbt_core_3_12_POETRY",
      "dbt_core_3_12_UV",
      "python_3_11_PIP",
      "python_3_11_POETRY",
      "python_3_11_UV",
      "python_3_12_PIP",
      "python_3_12_POETRY",
      "python_3_12_UV",
    ])
    error_message = "python and dbt_core must each render six task definitions, one per Python version and package manager."
  }

  assert {
    condition     = aws_ecs_task_definition.task_definition["python_3_12_PIP"].family == "awesome-compute_python_3_12_PIP_abcd1234"
    error_message = "The python task definition family name changed."
  }

  assert {
    condition     = aws_ecs_task_definition.task_definition["dbt_core_3_11_UV"].family == "awesome-compute_dbt_core_3_11_UV_abcd1234"
    error_message = "The dbt_core task definition family name changed."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.task_definition["python_3_12_PIP"].container_definitions)[0].image == "440744239605.dkr.ecr.eu-west-2.amazonaws.com/orchestra/python:3_12_PIP-2026.04.21-1"
    error_message = "The python image reference changed."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.task_definition["dbt_core_3_11_UV"].container_definitions)[0].image == "440744239605.dkr.ecr.eu-west-2.amazonaws.com/orchestra/dbt-core:3_11_UV-2026.04.27-0"
    error_message = "The dbt_core image reference changed."
  }

  assert {
    condition     = aws_kms_alias.orchestra_key_alias["python"].name == "alias/awesome-compute_integration_PYTHON_abcd1234"
    error_message = "The python KMS key alias changed."
  }

  assert {
    condition     = aws_iam_role.ecs_compute_task_roles["python"].name == "awesome-compute-orchestra-task-python-abcd1234"
    error_message = "The python task role name changed."
  }
}

run "bash_renders_a_single_default_task_definition" {
  variables {
    integrations = ["bash"]
  }

  assert {
    condition     = keys(aws_ecs_task_definition.task_definition) == ["bash_default"]
    error_message = "bash must render exactly one task definition."
  }

  assert {
    condition     = aws_ecs_task_definition.task_definition["bash_default"].family == "awesome-compute_bash_default_abcd1234"
    error_message = "The bash task definition family name is not awesome-compute_bash_default_abcd1234."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.task_definition["bash_default"].container_definitions)[0].name == "bash"
    error_message = "The bash container must be named bash - Orchestra addresses container overrides and log streams by this name."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.task_definition["bash_default"].container_definitions)[0].image == "440744239605.dkr.ecr.eu-west-2.amazonaws.com/orchestra/bash:default-2026.04.27-0"
    error_message = "The bash image tag must be prefixed with the default variant."
  }

  assert {
    condition     = aws_kms_alias.orchestra_key_alias["bash"].name == "alias/awesome-compute_integration_BASH_abcd1234"
    error_message = "The bash KMS key alias must exist and be uppercased - Orchestra will not create it at runtime."
  }

  assert {
    condition     = aws_iam_role.ecs_compute_task_roles["bash"].name == "awesome-compute-orchestra-task-bash-abcd1234"
    error_message = "The bash task role must exist - Orchestra only looks it up on self-managed compute."
  }

  assert {
    condition     = aws_ecs_task_definition.task_definition["bash_default"].cpu == "2048" && aws_ecs_task_definition.task_definition["bash_default"].memory == "4096"
    error_message = "bash must be sized the same as python."
  }

  assert {
    condition     = jsondecode(aws_ecs_task_definition.task_definition["bash_default"].container_definitions)[0].logConfiguration.options["awslogs-group"] == "/awesome-compute-orchestra/ecs-abcd1234"
    error_message = "bash must log to the shared compute log group."
  }
}

run "adding_bash_does_not_change_the_other_integrations" {
  variables {
    integrations = ["bash", "dbt_core", "python"]
  }

  assert {
    condition     = length(aws_ecs_task_definition.task_definition) == 13
    error_message = "Deploying all three integrations must render 6 + 6 + 1 task definitions."
  }

  assert {
    condition     = aws_ecs_task_definition.task_definition["python_3_12_PIP"].family == "awesome-compute_python_3_12_PIP_abcd1234"
    error_message = "Adding bash changed the python task definition family name."
  }

  assert {
    condition     = aws_kms_alias.orchestra_key_alias["dbt_core"].name == "alias/awesome-compute_integration_DBT_CORE_abcd1234"
    error_message = "Adding bash changed the dbt_core KMS key alias."
  }
}

run "unknown_integrations_are_rejected" {
  command = plan

  variables {
    integrations = ["ruby"]
  }

  expect_failures = [var.integrations]
}
