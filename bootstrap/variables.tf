variable "region" {
  type        = string
  description = "AWS region for the state bucket and lock table"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "Local AWS CLI profile. Leave null in CI."
  default     = null
}

variable "state_bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for Terraform state (e.g. shopfast-tfstate-yourname)"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table used for state locking"
  default     = "shopfast-tfstate-lock"
}
