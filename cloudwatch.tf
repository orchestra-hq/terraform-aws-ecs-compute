resource "aws_cloudwatch_log_group" "compute_log_group" {
  name              = "/${var.name_prefix}-orchestra/ecs-${random_id.random_suffix.hex}"
  retention_in_days = var.log_retention_days
  skip_destroy      = true
  tags              = local.tags
}
