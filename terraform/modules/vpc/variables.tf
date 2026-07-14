# ---------------------------------------------------------
# 1. Project Identity
# ---------------------------------------------------------
variable "project_name" {
  description = "Name used for tagging resources (e.g., shopfast)"
  type        = string
}

variable "region" {
  description = "The AWS region (e.g., us-east-1)"
  type        = string
}

# ---------------------------------------------------------
# 2. Network Sizing
# ---------------------------------------------------------
variable "vpc_cidr" {
  description = "The IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnets (Where the Load Balancer lives)
variable "public_subnet_cidr" {
  description = "IP range for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

# Private Subnets (Where the App and Database live)
variable "private_subnet_cidr" {
  description = "IP range for private subnet 1"
  type        = string
  default     = "10.0.10.0/24"
}