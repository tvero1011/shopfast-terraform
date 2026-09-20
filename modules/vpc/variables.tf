# ---------------------------------------------------------
# 1. Project identity
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
# 2. Network sizing
# ---------------------------------------------------------
variable "vpc_cidr" {
  description = "The IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP range for public subnet 1 (AZ a)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "IP range for public subnet 2 (AZ b)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "IP range for private subnet 1 (AZ a)"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_2_cidr" {
  description = "IP range for private subnet 2 (AZ b)"
  type        = string
  default     = "10.0.11.0/24"
}
