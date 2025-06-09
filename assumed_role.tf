resource "aws_iam_role" "role_assumed_from_orchestra" {
  name        = "${var.name_prefix}-orchestra-compute-${random_id.random_suffix.hex}"
  description = "IAM role assumed by Orchestra to for configuring compute operations."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.orchestra_aws_account_id}:root"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "ArnLike" : {
            "aws:PrincipalArn" : [
              "arn:aws:iam::${var.orchestra_aws_account_id}:role/assume_orchestra_${var.orchestra_account_id}",
            ]
          }
        }
      }
    ]
  })

  tags = local.tags
}

data "aws_iam_policy_document" "role_assumed_from_orchestra_policy_doc" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.secret_store.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.artifact_store.arn}",
      "${aws_s3_bucket.artifact_store.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
    ]
    resources = [
      aws_kms_key.orchestra_key.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeTasks",
      "ecs:StopTask",
      "ecs:TagResource"
    ]
    resources = [
      "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task/${aws_ecs_cluster.ecs_compute_cluster.name}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:RunTask",
      "ecs:TagResource"
    ]
    resources = [for arn in values(aws_ecs_task_definition.task_definition)[*].arn : replace(arn, "/:\\d+$/", ":*")]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "iam:GetRole"
    ]
    resources = [
      "${aws_iam_role.compute_execute_role.arn}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*-orchestra-task-*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:GetLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.compute_log_group.arn}:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeClusters",
    ]
    resources = [
      aws_ecs_cluster.ecs_compute_cluster.arn,
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "role_assumed_from_orchestra_policy" {
  name        = "${var.name_prefix}-orchestra-compute-${random_id.random_suffix.hex}-policy"
  path        = "/"
  description = "Permissions required by the compute assumed role to perform tasks on behalf of Orchestra."

  policy = data.aws_iam_policy_document.role_assumed_from_orchestra_policy_doc.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "role_assumed_from_orchestra_policy_attachment" {
  role       = aws_iam_role.role_assumed_from_orchestra.name
  policy_arn = aws_iam_policy.role_assumed_from_orchestra_policy.arn
}
