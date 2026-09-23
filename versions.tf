terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote, encrypted, locked state. The DB password lives in state, so local
  # state files must never be committed. Run `bootstrap/` once first, then
  # replace the value below with its output, then `terraform init -migrate-state`.
  # Backend blocks can't reference variables, so this is a literal string.
  # Locking is native S3 conditional-write locking (use_lockfile, Terraform
  # >= 1.10) — no DynamoDB lock table needed.
  backend "s3" {
    bucket       = "shopfast-tfstate-REPLACE-ME" # bootstrap output: state_bucket_name
    key          = "shopfast/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}