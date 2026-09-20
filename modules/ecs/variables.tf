# ---------------------------------------------------------
# 1. Identity and region
# ---------------------------------------------------------
variable "project_name" {
  type        = string
  description = "The prefix for all resources (e.g., shopfast)"
}

variable "region" {
  type        = string
  description = "AWS region, used for the log configuration"
}

# ---------------------------------------------------------
# 2. Networking
# ---------------------------------------------------------
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets where Fargate tasks run"
}

variable "fargate_security_group_id" {
  type        = string
  description = "Security group the tasks run with (allows 3000 from the ALB; trusted by RDS)"
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group the service registers its tasks with"
}

# ---------------------------------------------------------
# 3. Application config
# ---------------------------------------------------------
variable "ecr_repository_url" {
  type        = string
  description = "ECR repository URL containing the app image"
}

variable "db_instance_address" {
  type        = string
  description = "Database endpoint (DB_HOST)"
}

variable "db_name" {
  type        = string
  description = "Database name (DB_NAME)"
}

variable "db_username" {
  type        = string
  description = "Database user (DB_USER)"
}

variable "db_password_secret_arn" {
  type        = string
  description = "ARN of the secret whose 'password' key becomes DB_PASSWORD"
}

# ---------------------------------------------------------
# 4. Scaling
# ---------------------------------------------------------
variable "desired_count" {
  type        = number
  description = "Baseline (and minimum) number of tasks"
  default     = 2
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of tasks autoscaling may run"
  default     = 4
}

variable "cpu_target_percent" {
  type        = number
  description = "Average CPU % the autoscaler tries to hold"
  default     = 60
}
