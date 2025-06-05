data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "compute_execute_role" {
  name        = "${var.name_prefix}-orchestra-ecs-execution-role-${random_id.random_suffix.hex}"
  description = "IAM role for ECS task execution in compute environment"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "compute_execute_role_policy_attachment" {
  role       = aws_iam_role.compute_execute_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role_policy.arn
}

data "aws_iam_policy_document" "ecs_task_get_secrets_policy" {
  count = length(var.task_secrets) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters",
    ]
    resources = [
      for secret in var.task_secrets :
      secret.valueFrom
    ]
  }
}

resource "aws_iam_policy" "ecs_task_get_secrets_policy" {
  count = length(var.task_secrets) > 0 ? 1 : 0

  name   = "${var.name_prefix}-orchestra-ecs-get-secrets-${random_id.random_suffix.hex}"
  policy = data.aws_iam_policy_document.ecs_task_get_secrets_policy[0].json
}

resource "aws_iam_role_policy_attachment" "ecs_task_get_secrets_policy_attachment" {
  count = length(var.task_secrets) > 0 ? 1 : 0

  role       = aws_iam_role.compute_execute_role.name
  policy_arn = aws_iam_policy.ecs_task_get_secrets_policy[0].arn
}
