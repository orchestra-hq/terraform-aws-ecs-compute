resource "aws_kms_key" "orchestra_key" {
  description             = "Encryption key for Orchestra compute integrations"
  enable_key_rotation     = true
  rotation_period_in_days = var.key_rotation_period_days

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        "Sid" : "Allow administration + usage of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : [
          "kms:*"
        ],
        "Resource" : "*",
      },
    ]
  })

  tags = local.tags
}

resource "aws_kms_alias" "orchestra_key" {
  for_each = toset(local.integrations)

  name          = "alias/integration_${upper(each.value)}"
  target_key_id = aws_kms_key.orchestra_key.key_id
}

resource "aws_kms_alias" "orchestra_key_alias" {
  for_each = toset(local.integrations)

  name          = "alias/${var.name_prefix}_integration_${upper(each.value)}_${random_id.random_suffix.hex}"
  target_key_id = aws_kms_key.orchestra_key.key_id
}
