variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "networking-example"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "orchestra_account_id" {
  description = "Your Orchestra account ID"
  type        = string
  default     = "4a6a45ca-5549-4c53-bca4-43a76e1bab2c"
}
