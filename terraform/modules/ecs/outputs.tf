# ---------------------------------------------------------
# 1. Security & Connectivity
# ---------------------------------------------------------
output "ecs_sg_id" {
  description = "The Security Group ID for the ECS tasks (Used for DB firewall rules)"
  value       = aws_security_group.ecs_tasks.id
}

# ---------------------------------------------------------
# 2. Cluster Information
# ---------------------------------------------------------
output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.shopfast_api.name
}