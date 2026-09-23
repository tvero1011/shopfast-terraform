# ---------------------------------------------------------
# One-time bootstrap: creates the S3 bucket that the main ShopFast
# config uses as its remote state backend. State locking and
# encryption are handled natively by S3 (Terraform >= 1.10, via
# use_lockfile), so no DynamoDB lock table is needed.
#
# Chicken-and-egg problem: Terraform can't store its own state in a
# bucket that doesn't exist yet. So this is a small, separate config
# with its own LOCAL state, run once, before enabling the backend
# block in ../versions.tf.
#
# Usage:
#   cd bootstrap
#   terraform init
#   terraform apply -var="state_bucket_name=shopfast-tfstate-<something-unique>"
#   (copy the printed bucket name into ../versions.tf)
#   cd ..
#   terraform init -migrate-state   # moves existing local state into S3
# ---------------------------------------------------------
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "tfstate" {
  bucket = var.state_bucket_name

  # Lab convenience: lets `terraform destroy` remove the bucket even if old
  # state versions are left inside. Remove this for a real production bucket.
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled" # keeps prior state versions if something corrupts the latest one
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

