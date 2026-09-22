# ---------------------------------------------------------
# 1. The Connection (For the ECS Service)
# ---------------------------------------------------------
output "target_group_arn" {
  description = "The ARN of the target group. ECS needs this to register containers."
  value       = aws_lb_target_group.app.arn
}

# ---------------------------------------------------------
# 2. The Public Link (For the User)
# ---------------------------------------------------------
output "alb_dns_name" {
  description = "The public URL of your application."
  value       = aws_lb.main.dns_name
}

# ---------------------------------------------------------
# 3. For CloudWatch alarms (metric dimensions use the ARN suffix, not the full ARN)
# ---------------------------------------------------------
output "alb_arn_suffix" {
  description = "ALB ARN suffix, used as a CloudWatch alarm dimension"
  value       = aws_lb.main.arn_suffix
}

output "target_group_arn_suffix" {
  description = "Target group ARN suffix, used as a CloudWatch alarm dimension"
  value       = aws_lb_target_group.app.arn_suffix
}