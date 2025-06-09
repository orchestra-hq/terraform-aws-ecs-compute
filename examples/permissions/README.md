# Permissions

This example demonstrates how to add custom IAM permissions to the ECS compute cluster's task roles. In this case, we're adding permissions to list objects in an S3 bucket.

This allows the Python compute tasks run from Orchestra to list objects in an S3 bucket.

## Configuration

The example adds an IAM policy that allows the Python task role to:

- List objects in an S3 bucket (`s3:ListBucket`)
- Get the bucket location (`s3:GetBucketLocation`)
