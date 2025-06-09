locals {
  ecr_account_mapping = {
    "355563318157" : "440744239605",
    "064157540096" : "195275647980",
    "383742555833" : "850995545977",
  }
  python_versions = ["3_12", "3_11"]
  ecr_image_names = {
    "dbt_core" = "orchestra/dbt-core"
    "python"   = "orchestra/python"
  }
  task_defs = flatten([
    for integration in local.integrations : [
      for python_version in local.python_versions : {
        integration    = integration
        python_version = python_version
        cpu            = var.compute_resources[integration].cpu
        memory         = var.compute_resources[integration].memory
        image          = local.ecr_image_names[integration]
      }
    ]
  ])
}

resource "aws_ecs_task_definition" "task_definition" {
  for_each = { for task in local.task_defs : "${task.integration}_${task.python_version}" => task }

  family                   = "${var.name_prefix}_${each.key}_PIP_${random_id.random_suffix.hex}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory

  execution_role_arn = aws_iam_role.compute_execute_role.arn

  container_definitions = jsonencode([
    {
      name        = each.value.integration
      image       = "${local.ecr_account_mapping[var.orchestra_aws_account_id]}.dkr.ecr.${var.region}.amazonaws.com/${each.value.image}:${each.value.python_version}_PIP-${var.image_tags[each.value.integration]}"
      cpu         = each.value.cpu
      memory      = each.value.memory
      environment = var.task_env_vars,
      secrets     = var.task_secrets,
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.compute_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = each.value.integration
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = merge(
    local.tags,
    {
      "NewLogGroup" = "true"
    }
  )
}
