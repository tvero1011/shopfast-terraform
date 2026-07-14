variable "project_name" {
  type        = string
  description = "Project name used for naming the RDS instance and secret"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the RDS security group will be created"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets (2+ AZs) for the RDS subnet group"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group of the app tasks; the only source allowed on port 5432"
}

variable "db_name" {
  type        = string
  description = "Initial database name (single source of truth; passed to the app)"
  default     = "shopfastdb"
}

variable "db_username" {
  type        = string
  description = "Database master username (single source of truth; passed to the app)"
  default     = "postgres"
}

variable "multi_az" {
  type        = bool
  description = "Standby replica in a second AZ. Doubles DB cost; enable for production."
  default     = false
}

variable "backup_retention_days" {
  type        = number
  description = "Automated backup retention in days (0 disables backups)"
  default     = 1
}

variable "deletion_protection" {
  type        = bool
  description = "Block accidental deletion. Enable for production."
  default     = false
}
