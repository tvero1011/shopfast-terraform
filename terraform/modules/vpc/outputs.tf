# The VPC ID is needed by almost every other module
output "vpc_id" {
  value = aws_vpc.main.id
}

# Public Subnets (Used by the Load Balancer)
output "public_subnet_ids" {
  value = [aws_subnet.public.id, aws_subnet.public_2.id]
}

# Private Subnets (Used by ECS Tasks and RDS)
# Note: RDS requires at least 2 subnets in different AZs
output "private_subnet_ids" {
  value = [aws_subnet.private.id, aws_subnet.private_2.id]
}

# The Security Group for the Load Balancer
# We export this so the ECS module can allow traffic FROM it
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

# The VPC CIDR block (Used for security group rules)
output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

# The Security Group for Fargate Tasks
# Used by the ECS module to attach to the service
output "fargate_security_group_id" {
  value       = aws_security_group.fargate_sg.id
  description = "Security group ID for Fargate tasks"
}

# The Security Group for VPC Endpoints
# Sometimes useful if you want to tighten RDS rules to only allow 
# traffic from specific interface endpoints
output "endpoint_security_group_id" {
  value       = aws_security_group.endpoint_sg.id
  description = "Security group ID for VPC Endpoints"
}

# Export individual subnet IDs if your RDS module expects a list 
# or if you need to target a specific AZ
output "private_subnet_1_id" {
  value = aws_subnet.private.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
}