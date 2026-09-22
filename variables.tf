# ---------------------------------------------------------
# 1. Identity
# ---------------------------------------------------------
variable "project_name" {
  description = "Prefix used for naming all AWS resources"
  type        = string
  default     = "shopfast"
}

variable "region" {
  description = "AWS region where everything is deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Local AWS CLI profile for Terraform. Leave null in CI."
  type        = string
  default     = null
}

# ---------------------------------------------------------
# 2. Network
# ---------------------------------------------------------
variable "vpc_cidr" {
  description = "IP range for the whole VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# ---------------------------------------------------------
# 3. CI/CD (GitHub Actions -> AWS via OIDC)
# ---------------------------------------------------------
variable "github_repo" {
  description = "GitHub repository allowed to deploy, as 'owner/name'"
  type        = string
}

variable "github_branch" {
  description = "Only this branch may assume the deploy role"
  type        = string
  default     = "main"
}

variable "create_github_oidc_provider" {
  description = "Set false if this AWS account already has the GitHub OIDC provider (only one is allowed per account)"
  type        = bool
  default     = true
}

# ---------------------------------------------------------
# 4. Observability
# ---------------------------------------------------------
variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications. Leave null to create the SNS topic without a subscription."
  type        = string
  default     = null
}
