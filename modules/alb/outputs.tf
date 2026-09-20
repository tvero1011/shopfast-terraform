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