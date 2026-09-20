locals {
  container_name = "${var.project_name}-api"
  container_port = 3000
}

# ---------------------------------------------------------
# 1. ECS Cluster
# ---------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ---------------------------------------------------------
# 2. IAM: the EXECUTION role (what ECS itself needs to launch the task).
# There is deliberately no TASK role: the app makes no AWS API calls.
# ---------------------------------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Pull images from ECR and write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "ecs_execution_standard" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Least privilege: read exactly one secret
resource "aws_iam_role_policy" "ecs_secrets_policy" {
  name = "${var.project_name}-secrets-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "secretsmanager:GetSecretValue"
      Effect   = "Allow"
      Resource = var.db_password_secret_arn
    }]
  })
}

# ---------------------------------------------------------
# 3. Logging
# ---------------------------------------------------------
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-api"
  retention_in_days = 7
}

# ---------------------------------------------------------
# 4. Task definition (the app "recipe")
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
      name      = local.container_name
      image     = "${var.ecr_repository_url}:latest" # bootstrap image; CI deploys immutable commit-SHA tags
      essential = true

      portMappings = [{
        containerPort = local.container_port
        hostPort      = local.container_port
      }]

      # Run a tiny init as PID 1 so SIGTERM is forwarded and zombie processes are reaped
      linuxParameters = { initProcessEnabled = true }

      # Read only the 'password' key from the JSON secret
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_password_secret_arn}:password::"
        }
      ]

      environment = [
        { name = "DB_HOST", value = var.db_instance_address },
        { name = "DB_NAME", value = var.db_name },
        { name = "DB_USER", value = var.db_username }
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
# 5. ECS Service
# Terraform owns the infrastructure; the CI/CD pipeline owns which image runs.
# So task_definition and desired_count are ignored after creation, otherwise
# every 'terraform apply' would undo the pipeline's deployment or autoscaling.
# ---------------------------------------------------------
resource "aws_ecs_service" "shopfast_api" {
  name                              = "${var.project_name}-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.shopfast_api.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60

  depends_on = [aws_cloudwatch_log_group.ecs]

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.fargate_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = local.container_port
  }

  # A deployment whose tasks keep failing is stopped and rolled back automatically
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# ---------------------------------------------------------
# 6. Autoscaling (horizontal): hold average CPU near the target
# ---------------------------------------------------------
resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.shopfast_api.name}"
  min_capacity       = var.desired_count
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.project_name}-cpu-target-tracking"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  resource_id        = aws_appautoscaling_target.ecs.resource_id

  target_tracking_scaling_policy_configuration {
    target_value       = var.cpu_target_percent
    scale_out_cooldown = 60
    scale_in_cooldown  = 120

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
