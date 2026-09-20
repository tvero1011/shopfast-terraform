variable "project_name" {
  type        = string
  description = "Prefix for naming"
}

variable "github_repo" {
  type        = string
  description = "Repository allowed to deploy, as owner/name"
}

variable "github_branch" {
  type        = string
  description = "Only this branch may assume the role"
  default     = "main"
}

variable "create_oidc_provider" {
  type        = bool
  description = "Create the GitHub OIDC provider. Only one per AWS account is allowed; set false to reuse an existing one."
  default     = true
}

variable "ecr_repository_arn" {
  type        = string
  description = "ECR repository the pipeline may push to"
}

variable "ecs_service_arn" {
  type        = string
  description = "ECS service the pipeline may update"
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "Execution role the pipeline must be allowed to pass to ECS"
}
