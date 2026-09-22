output "state_bucket_name" {
  description = "Paste into versions.tf backend block as 'bucket'"
  value       = aws_s3_bucket.tfstate.bucket
}

output "lock_table_name" {
  description = "Paste into versions.tf backend block as 'dynamodb_table'"
  value       = aws_dynamodb_table.tfstate_lock.name
}
