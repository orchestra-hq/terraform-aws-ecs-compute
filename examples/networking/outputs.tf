output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.main.id
}

output "compute_cluster_name" {
  description = "The name of the ECS cluster created by this module."
  value       = module.ecs-compute.compute_cluster_name
}

output "compute_cluster_arn" {
  description = "The ARN of the ECS cluster created by this module."
  value       = module.ecs-compute.compute_cluster_arn
}

output "assumed_role_arn" {
  description = "The ARN of the IAM role assumed by Orchestra to perform compute operations."
  value       = module.ecs-compute.assumed_role_arn
}

output "assumed_role_name" {
  description = "The name of the IAM role assumed by Orchestra to perform compute operations."
  value       = module.ecs-compute.assumed_role_name
}

output "artifact_store_bucket_id" {
  description = "The name of the S3 bucket used to store artifacts generated during a compute task."
  value       = module.ecs-compute.artifact_store_bucket_id
}

output "secret_store_bucket_id" {
  description = "The name of the S3 bucket used to temporarily store secrets used during a compute task."
  value       = module.ecs-compute.secret_store_bucket_id
}
