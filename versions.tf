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

  # Recommended for anything beyond a lab: remote, encrypted, locked state.
  # The DB password lives in state, so local state files must never be committed.
  # backend "s3" {
  #   bucket         = "YOUR-TFSTATE-BUCKET"
  #   key            = "shopfast/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "YOUR-TFSTATE-LOCK-TABLE"
  #   encrypt        = true
  # }
}
