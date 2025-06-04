# Role for each compute task to assume in order to perform tasks whilst executing code
# Only used in client compute environments.

resource "aws_iam_role" "ecs_compute_task_roles" {
  for_each = toset(local.integrations)

  name        = "${var.name_prefix}-orchestra-task-${each.key}-${random_id.random_suffix.hex}"
  description = "IAM role used by ECS task to perform correct actions."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
          },
          "ArnLike" : {
            "aws:SourceArn" : "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })

  tags = local.tags
}

data "aws_iam_policy_document" "ecs_compute_task_role_policy_doc" {
  for_each = toset(local.integrations)
  version  = "2012-10-17"

  # permissions for secrets
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    resources = [
      "${aws_s3_bucket.secret_store.arn}/${each.key}/*",
    ]
  }

  # permissions for artifacts
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.artifact_store.arn}/${each.key}/*",
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.artifact_store.arn]
  }

  # permissions for kms
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.orchestra_key.arn]
  }
}

resource "aws_iam_policy" "ecs_compute_task_role_policy" {
  for_each    = toset(local.integrations)
  name        = "${var.name_prefix}-orchestra-task-${each.key}-${random_id.random_suffix.hex}-policy"
  description = "Permissions required by the ECS task role to perform tasks on behalf of Orchestra."

  policy = data.aws_iam_policy_document.ecs_compute_task_role_policy_doc[each.key].json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ecs_compute_task_role_policy_attachment" {
  for_each   = toset(local.integrations)
  role       = aws_iam_role.ecs_compute_task_roles[each.key].name
  policy_arn = aws_iam_policy.ecs_compute_task_role_policy[each.key].arn
}
