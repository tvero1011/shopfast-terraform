output "role_arn" {
  description = "Role ARN GitHub Actions assumes (store as the AWS_ROLE_ARN repository variable)"
  value       = aws_iam_role.github_actions.arn
}

output "terraform_plan_role_arn" {
  description = "Read-only role ARN for PR plan workflows (store as the TF_PLAN_ROLE_ARN repository variable)"
  value       = aws_iam_role.terraform_plan.arn
}
