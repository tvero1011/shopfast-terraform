# ---------------------------------------------------------
# 1. Project Identity
# ---------------------------------------------------------
variable "project_name" {
  type        = string
  description = "The name of the project, used for naming the ALB and Target Group"
}

# ---------------------------------------------------------
# 2. Network Placement
# ---------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the Target Group will be created"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The list of PUBLIC subnets where the ALB will listen for internet traffic"
}

# ---------------------------------------------------------
# 3. Security
# ---------------------------------------------------------
variable "alb_security_group_id" {
  type        = string
  description = "The Security Group ID that allows Port 80 traffic from the world"
}