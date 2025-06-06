output "compute_cluster_name" {
  value       = split("/", aws_ecs_cluster.ecs_compute_cluster.arn)[1]
  description = "The name of the ECS cluster created by this module."
}

output "compute_cluster_arn" {
  value       = aws_ecs_cluster.ecs_compute_cluster.arn
  description = "The ARN of the ECS cluster created by this module."
}

output "assumed_role_arn" {
  value       = aws_iam_role.role_assumed_from_orchestra.arn
  description = "The ARN of the IAM role assumed by Orchestra to perform compute operations."
}

output "assumed_role_name" {
  value       = aws_iam_role.role_assumed_from_orchestra.name
  description = "The name of the IAM role assumed by Orchestra to perform compute operations."
}

output "artifact_store_bucket_id" {
  value       = aws_s3_bucket.artifact_store.id
  description = "The name of the S3 bucket used to store artifacts generated during a compute task."
}

output "secret_store_bucket_id" {
  value       = aws_s3_bucket.secret_store.id
  description = "The name of the S3 bucket used to temporarily store secrets used during a compute task."
}

output "integration_task_role_arns" {
  value       = aws_iam_role.ecs_compute_task_roles[*].arn
  description = "The ARNs of the IAM roles created for each integration compute task."
}
