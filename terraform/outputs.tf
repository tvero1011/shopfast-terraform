# ---------------------------------------------------------
# 1. The Application Access (The Big Prize)
# ---------------------------------------------------------
output "final_app_url" {
  description = "Click this to see your live website!"
  value       = "http://${module.alb.alb_dns_name}"
}

# ---------------------------------------------------------
# 2. Deployment Info (How to push your Docker image)
# ---------------------------------------------------------
output "ecr_repository_url" {
  description = "The destination for your Docker images"
  value       = module.ecr.repository_url
}

# ---------------------------------------------------------
# 3. Backend & Database (For your app config)
# ---------------------------------------------------------
output "db_hostname" {
  description = "The address of your private database"
  value       = module.rds.db_instance_address
}

output "db_password_secret_arn" {
  description = "The 'ID' of the secret in Secrets Manager"
  value       = module.rds.db_password_secret_arn
}

# ---------------------------------------------------------
# 4. Networking (For verification)
# ---------------------------------------------------------
output "vpc_id" {
  description = "The VPC where all resources are living"
  value       = module.vpc.vpc_id
}