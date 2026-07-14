# ---------------------------------------------------------
# 1. ECS Cluster: The Management Home
# ---------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled" 
  }
}

# ---------------------------------------------------------
# 2. IAM Roles: Permissions for the Service
# ---------------------------------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Basic permissions: Pull ECR images and create CloudWatch logs
resource "aws_iam_role_policy_attachment" "ecs_execution_standard" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom permission: Read the specific DB secret
resource "aws_iam_role_policy" "ecs_secrets_policy" {
  name = "${var.project_name}-secrets-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = var.db_password_secret_arn
      }
    ]
  })
}

# ---------------------------------------------------------
# 3. Security: Firewall for the Tasks
# ---------------------------------------------------------
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Allow inbound traffic from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [var.alb_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# ---------------------------------------------------------
# 4. Task Definition: The App Recipe
# ---------------------------------------------------------
resource "aws_ecs_task_definition" "shopfast_api" {
  family                   = "${var.project_name}-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "shopfast-api"
      image     = "${var.ecr_repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
      }]

      # Fetching the password key from our JSON secret
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_password_secret_arn}:password::"
        }
      ]
      
      environment = [
        { name = "DB_HOST", value = var.db_instance_address }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ---------------------------------------------------------
# 5. Logging: Where the logs go
# ---------------------------------------------------------
resource "aws_cloudwatch_log_group" "ecs" { 
  name              = "/ecs/${var.project_name}-api" 
  retention_in_days = 7
}

# ---------------------------------------------------------
# 6. ECS Service: The Engine
# ---------------------------------------------------------
resource "aws_ecs_service" "shopfast_api" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.shopfast_api.arn
  desired_count   = 2 
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 60

  # This ensures the log group exists BEFORE the service tries to start
  depends_on = [aws_cloudwatch_log_group.ecs]

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false 
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "shopfast-api"
    container_port   = 3000
  }
}