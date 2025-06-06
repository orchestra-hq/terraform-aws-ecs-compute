# Allows the python task role to list objects in an S3 bucket
resource "aws_iam_policy" "allow_s3_listing" {
  name        = "allow-s3-listing"
  description = "Policy to allow listing objects in an S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::example-bucket-name" # Replace with your bucket name
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_compute_python_task_role_s3_attachment" {
  role       = module.ecs-compute.integration_task_role_names["python"]
  policy_arn = aws_iam_policy.allow_s3_listing.arn
}
