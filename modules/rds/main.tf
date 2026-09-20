# ---------------------------------------------------------
# 1. The Vault (generated password + Secrets Manager)
# ---------------------------------------------------------

# Random password so nobody ever types or knows it.
# NOTE: this value is stored in Terraform state, so state must be protected.
resource "random_password" "db_password" {
  length  = 16
  special = false # avoids escaping problems in connection strings
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project_name}-db-credentials"
  description             = "Database credentials for ${var.project_name}"
  recovery_window_in_days = 0 # lab setting: delete immediately on destroy so the name can be reused
}

resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_db_instance.main.address
    port     = 5432
    dbName   = var.db_name
  })
}

# ---------------------------------------------------------
# 2. Networking and firewall
# ---------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids # RDS requires subnets in at least 2 AZs
  tags       = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow Postgres (5432) from the app tasks only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id] # SG chaining: only the app's security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------
# 3. The database (PostgreSQL)
# ---------------------------------------------------------
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "16" # major only: AWS picks a current minor; avoids pinning a retired minor version
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_days
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = true # lab setting; set false and add final_snapshot_identifier for real data
}
