output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.shopfast_api.name
}

output "service_arn" {
  description = "ARN of the ECS service (used to scope the CI/CD role)"
  value       = aws_ecs_service.shopfast_api.id
}

output "task_family" {
  description = "Task definition family (the pipeline fetches the latest revision of this)"
  value       = aws_ecs_task_definition.shopfast_api.family
}

output "execution_role_arn" {
  description = "Execution role ARN (the CI/CD role needs iam:PassRole on it)"
  value       = aws_iam_role.ecs_execution_role.arn
}
