# ---------------------------------------------------------
# 1. The application
# ---------------------------------------------------------
output "final_app_url" {
  description = "Public URL of the app (ALB DNS name)"
  value       = "http://${module.alb.alb_dns_name}"
}

# ---------------------------------------------------------
# 2. Deployment info
# ---------------------------------------------------------
output "ecr_repository_url" {
  description = "Where Docker images are pushed"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name (GitHub variable ECS_CLUSTER)"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name (GitHub variable ECS_SERVICE)"
  value       = module.ecs.service_name
}

output "ecs_task_family" {
  description = "Task definition family (GitHub variable TASK_FAMILY)"
  value       = module.ecs.task_family
}

output "github_actions_role_arn" {
  description = "IAM role GitHub Actions assumes (GitHub variable AWS_ROLE_ARN)"
  value       = module.github_oidc.role_arn
}

# ---------------------------------------------------------
# 3. Backend and database
# ---------------------------------------------------------
output "db_hostname" {
  description = "Private address of the database"
  value       = module.rds.db_instance_address
}

output "db_password_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the DB credentials"
  value       = module.rds.db_password_secret_arn
}

# ---------------------------------------------------------
# 4. Networking
# ---------------------------------------------------------
output "vpc_id" {
  description = "The VPC everything lives in"
  value       = module.vpc.vpc_id
}
