variable "name_prefix" {
  description = "The name prefix to use for the resources created by this module."
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 25
    error_message = "The name prefix must be less than 25 characters."
  }
  validation {
    condition     = length(var.name_prefix) >= 5
    error_message = "The name prefix must be at least 5 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name prefix must only contain lowercase letters, numbers, and hyphens (-)."
  }
}

variable "orchestra_aws_account_id" {
  description = "The Orchestra AWS account ID. Note: this is provided by default and does not need to be set manually."
  type        = string
  default     = "355563318157"
}

variable "log_retention_days" {
  description = "The number of days to retain CloudWatch logs produced by compute tasks."
  type        = number
  default     = 90
}

variable "key_rotation_period_days" {
  description = "The number of days to rotate the KMS key used to encrypt secrets."
  type        = number
  default     = 365
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "enable_container_insights" {
  description = "Whether to enable Container Insights for the ECS cluster. Note: this will incur additional AWS charges."
  type        = bool
  default     = false
}

variable "enhanced_container_insights" {
  description = "Whether to use Enhanced Container Insights for the ECS cluster. Requires enable_container_insights to be true. Note: this will incur additional AWS charges."
  type        = bool
  default     = false
}

variable "integrations" {
  description = "The integrations to deploy."
  type        = list(string)
}

variable "image_tags" {
  description = "A map representing the ECR image tags to use for each integration."
  type        = map(string)
  default = {
    python   = "2025.06.30-0",
    dbt_core = "2025.06.27-0"
  }
  validation {
    condition     = alltrue([for k in var.integrations : contains(keys(var.image_tags), lower(k))])
    error_message = "Each integration must have an image tag defined."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden)."
}

variable "compute_resources" {
  description = "A map representing the compute resources (CPU and memory) to use for each integration."
  type = map(object({
    cpu    = number
    memory = number
  }))
  default = {
    python   = { cpu = 2048, memory = 4096 }
    dbt_core = { cpu = 4096, memory = 8192 }
  }
  validation {
    condition     = alltrue([for k in var.integrations : contains(keys(var.compute_resources), lower(k))])
    error_message = "Each integration must have compute resources defined."
  }
}

variable "orchestra_account_id" {
  description = "Your Orchestra account ID, which can be found in the Account Settings page on Orchestra."
  type        = string
}

variable "task_env_vars" {
  description = "Environment variables to set on the ECS task when it runs."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "task_secrets" {
  description = "Secrets to set on the ECS task when it runs. This will inject sensitive data into your containers as environment variables. The full ARNs of the secrets must be provided for this module."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}
