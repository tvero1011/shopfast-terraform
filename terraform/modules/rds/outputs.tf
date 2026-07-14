output "db_instance_address" {
  description = "The hostname of the RDS instance (e.g., shopfast-db.xyz.us-east-1.rds.amazonaws.com)"
  value       = aws_db_instance.main.address
}

output "db_password_secret_arn" {
  description = "The ARN of the Secrets Manager secret containing the DB password"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository created inside the RDS module"
  value       = aws_ecr_repository.app.repository_url
}