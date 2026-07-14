variable "project_name" {
  type        = string
  description = "Project name used for naming the RDS instance and Secret"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the RDS security group will be created"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of private subnets for the RDS Subnet Group"
}

variable "ecs_sg_id" {
  type        = string
  description = "The Security Group ID of the ECS tasks to allow database access (Port 5432)"
}