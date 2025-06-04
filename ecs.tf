resource "aws_ecs_cluster" "ecs_compute_cluster" {
  name = "${var.name_prefix}-orchestra-compute-cluster-${random_id.random_suffix.hex}"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? (var.enhanced_container_insights ? "enhanced" : "enabled") : "disabled"
  }

  tags = local.tags
}
