terraform {
  required_version = ">= 1.5.0"

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
  # replace the two values below with its outputs, then `terraform init -migrate-state`.
  # Backend blocks can't reference variables, so these are literal strings.
  backend "s3" {
    bucket         = "shopfast-tfstate-REPLACE-ME" # bootstrap output: state_bucket_name
    key            = "shopfast/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "shopfast-tfstate-lock"       # bootstrap output: lock_table_name
    encrypt        = true
  }
}
