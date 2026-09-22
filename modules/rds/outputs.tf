output "db_instance_address" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_password_secret_arn" {
  description = "The ARN of the Secrets Manager secret containing the DB credentials"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "db_name" {
  description = "Database name (passed to the app as DB_NAME)"
  value       = var.db_name
}

output "db_username" {
  description = "Database username (passed to the app as DB_USER)"
  value       = var.db_username
}

output "db_instance_id" {
  description = "RDS instance identifier, used as a CloudWatch alarm dimension"
  value       = aws_db_instance.main.id
}
