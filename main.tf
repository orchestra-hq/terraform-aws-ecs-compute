// main.tf
// This is the primary entrypoint for the Terraform module. 

resource "aws_ecs_cluster" "compute_cluster" {
  name = "orchestra-compute-cluster"
}
