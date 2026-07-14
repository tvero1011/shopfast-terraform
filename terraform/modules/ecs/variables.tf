# ---------------------------------------------------------
# 1. Identity & Region
# ---------------------------------------------------------
variable "project_name" {
  type        = string
  description = "The prefix for all resources (e.g., shopfast)"
}

variable "region" {
  type        = string
  description = "The AWS region (e.g., us-east-1) used for logs and service endpoints"
}

# ---------------------------------------------------------
# 2. Networking (Infrastructure Inputs)
# ---------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the ECS service will live"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The isolated subnets where Fargate tasks will run"
}

variable "alb_security_group_id" {
  type        = string
  description = "The ID of the ALB security group to allow inbound traffic to tasks"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the Target Group where the ALB routes traffic"
}

# ---------------------------------------------------------
# 3. Application Config (Data Inputs)
# ---------------------------------------------------------
variable "db_instance_address" {
  type        = string
  description = "The database endpoint (DB_HOST)"
}

variable "db_password_secret_arn" {
  type        = string
  description = "The ARN of the secret containing the DB password"
}

variable "ecr_repository_url" {
  type        = string
  description = "The URL of the ECR repository containing your Docker image"
}