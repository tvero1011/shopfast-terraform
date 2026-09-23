output "state_bucket_name" {
  description = "Paste into versions.tf backend block as 'bucket'"
  value       = aws_s3_bucket.tfstate.bucket
}
