# ---------------------------------------------------------
# 1. Identity (The "Name Tag" for everything)
# ---------------------------------------------------------
variable "project_name" {
  description = "The prefix used for naming all our AWS resources"
  type        = string
  default     = "shopfast"
}

variable "region" {
  description = "The AWS location where our infrastructure will live"
  type        = string
  default     = "us-east-1"
}

# ---------------------------------------------------------
# 2. Network Layout (The "Map" of our VPC)
# ---------------------------------------------------------
# We put these here so we don't have to hunt inside modules to change IP ranges
variable "vpc_cidr" {
  description = "The main IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range for the first public subnet (ALB lives here)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "IP range for the first private subnet (App & DB live here)"
  type        = string
  default     = "10.0.10.0/24"
}