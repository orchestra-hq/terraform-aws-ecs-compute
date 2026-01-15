# AWS permission requirements

The minimal AWS permissions required to use this Terraform module are:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECSServicePermissions",
      "Effect": "Allow",
      "Action": [
        "ecs:ListClusters",
        "ecs:ListTaskDefinitions",
        "ecs:DescribeTaskDefinition",
        "ecs:ListTasks",
        "ecs:CreateCluster",
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ECSManagePermissions",
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeClusters",
        "ecs:UpdateCluster",
        "ecs:DeleteCluster",
        "ecs:TagResource",
        "ecs:UntagResource",
        "ecs:ListTagsForResource",
        "ecs:DescribeTasks",
        "ecs:RunTask",
        "ecs:StopTask",
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition"
      ],
      "Resource": [
        "arn:aws:ecs:*:*:cluster/*-orchestra-compute-cluster-*",
        "arn:aws:ecs:*:*:task-definition/*dbt_core*:*",
        "arn:aws:ecs:*:*:task-definition/*python*:*",
        "arn:aws:ecs:*:*:task/*-orchestra-compute-cluster-*/*"
      ]
    },
    {
      "Sid": "IAMListPermissions",
      "Effect": "Allow",
      "Action": [
        "iam:ListPolicies",
        "iam:ListRoles"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IAMRolePermissions",
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfilesForRole",
        "iam:UpdateRole",
        "iam:UpdateRoleDescription",
        "iam:DeleteRole",
        "iam:TagRole",
        "iam:UntagRole",
        "iam:ListRoleTags",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy"
      ],
      "Resource": [
        "arn:aws:iam::*:role/*-orchestra-ecs-execution-role-*",
        "arn:aws:iam::*:role/*-orchestra-task-*-*",
        "arn:aws:iam::*:role/*-orchestra-compute-*"
      ]
    },
    {
      "Sid": "IAMPolicyPermissions",
      "Effect": "Allow",
      "Action": [
        "iam:CreatePolicy",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:ListPolicyVersions",
        "iam:DeletePolicy",
        "iam:TagPolicy",
        "iam:UntagPolicy",
        "iam:ListPolicyTags"
      ],
      "Resource": [
        "arn:aws:iam::*:policy/*-orchestra-ecs-execution-role-*-policy",
        "arn:aws:iam::*:policy/*-orchestra-task-*-*-policy",
        "arn:aws:iam::*:policy/*-orchestra-compute-*-policy",
        "arn:aws:iam::*:policy/*-orchestra-ecs-get-secrets-*"
      ]
    },
    {
      "Sid": "IAMManagedPolicyRead",
      "Effect": "Allow",
      "Action": [
        "iam:GetPolicy",
        "iam:GetPolicyVersion"
      ],
      "Resource": [
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
      ]
    },
    {
      "Sid": "S3ListAllBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3BucketPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:Get*Configuration",
        "s3:GetBucket*",
        "s3:PutBucket*",
        "s3:DeleteBucket",
        "s3:DeleteBucketPolicy",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:*Lifecycle*"
      ],
      "Resource": [
        "arn:aws:s3:::*-orchestra-secrets-*",
        "arn:aws:s3:::*-orchestra-artifacts-*"
      ]
    },
    {
      "Sid": "S3ObjectPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObjectAcl",
        "s3:PutObjectTagging",
        "s3:GetObjectTagging",
        "s3:DeleteObjectTagging"
      ],
      "Resource": [
        "arn:aws:s3:::*-orchestra-secrets-*/*",
        "arn:aws:s3:::*-orchestra-artifacts-*/*"
      ]
    },
    {
      "Sid": "KMSListPermissions",
      "Effect": "Allow",
      "Action": [
        "kms:CreateKey",
        "kms:ListKeys",
        "kms:ListAliases"
      ],
      "Resource": "*"
    },
    {
      "Sid": "KMSPermissions",
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:ListKeyPolicies",
        "kms:PutKeyPolicy",
        "kms:UpdateKeyDescription",
        "kms:EnableKeyRotation",
        "kms:DisableKeyRotation",
        "kms:GetKeyRotationStatus",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ListResourceTags",
        "kms:CreateAlias",
        "kms:DeleteAlias",
        "kms:UpdateAlias"
      ],
      "Resource": [
        "arn:aws:kms:*:*:key/*",
        "arn:aws:kms:*:*:alias/*_integration_*_*"
      ]
    },
    {
      "Sid": "CloudWatchLogsListPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogGroups",
        "logs:ListTagsForResource"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:PutRetentionPolicy",
        "logs:DeleteRetentionPolicy",
        "logs:DeleteLogGroup",
        "logs:TagLogGroup",
        "logs:UntagLogGroup",
        "logs:TagResource",
        "logs:UntagResource",
        "logs:GetLogEvents",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:log-group:/*-orchestra/ecs-*",
        "arn:aws:logs:*:*:log-group:/*-orchestra/ecs-*:*"
      ]
    },
    {
      "Sid": "STSCallerIdentity",
      "Effect": "Allow",
      "Action": [
        "sts:GetCallerIdentity"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2DescribePermissions",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeNetworkInterfaces"
      ],
      "Resource": "*"
    }
  ]
}
```
