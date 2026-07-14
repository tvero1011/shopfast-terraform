# ---------------------------------------------------------
# 1. The Vault (Passwords & Secrets)
# ---------------------------------------------------------

# Generate a random password so we never have to type it manually
resource "random_password" "db_password" {
  length  = 16
  special = false 
}

# The container for our secret
resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.project_name}-db-secret-v4" # Incremented version
  description = "Database credentials for ${var.project_name}"
  recovery_window_in_days = 0 
}

# The actual JSON data inside the secret
resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_db_instance.main.address # Links to the DB below
    port     = 5432
    dbName   = "shopfastdb"
  })
}

# ---------------------------------------------------------
# 2. Security (Firewalls & Subnets)
# ---------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow port 5432 from ECS tasks only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id] # Only allows the App to talk to it
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------
# 3. The Database (Postgres)
# ---------------------------------------------------------

resource "aws_db_instance" "main" {
  identifier           = "${var.project_name}-db"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t4g.micro" # Cost-effective ARM instance
  allocated_storage    = 20
  db_name              = "shopfastdb"
  username             = "postgres"
  password             = random_password.db_password.result
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  skip_final_snapshot  = true
  publicly_accessible  = false # Keeps the DB off the internet
  storage_type         = "gp3"
}

# ---------------------------------------------------------
# 4. Artifact Storage (Docker Repository)
# ---------------------------------------------------------

resource "aws_ecr_repository" "app" {
  name                 = "${var.project_name}-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}