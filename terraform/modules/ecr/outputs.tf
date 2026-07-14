# ---------------------------------------------------------
# ECR Outputs: The "Address" of your Warehouse
# ---------------------------------------------------------

output "repository_url" {
  description = "The URL for Docker login, tag, and push commands"
  value       = aws_ecr_repository.api.repository_url
}

output "repository_arn" {
  description = "The Amazon Resource Name (ARN) of the repository"
  value       = aws_ecr_repository.api.arn
}