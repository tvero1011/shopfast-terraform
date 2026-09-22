variable "project_name" {
  type        = string
  description = "Prefix used for naming alarms and the SNS topic"
}

variable "alert_email" {
  type        = string
  description = "Email to notify on alarm state changes. Leave null to skip the subscription."
  default     = null
}

variable "cpu_alarm_threshold" {
  type        = number
  description = "CPU percent that triggers the ECS/RDS CPU alarms"
  default     = 80
}

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name (alarm dimension)"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name (alarm dimension)"
}

variable "alb_arn_suffix" {
  type        = string
  description = "ALB ARN suffix, e.g. app/my-alb/50dc6c495c0c9188"
}

variable "target_group_arn_suffix" {
  type        = string
  description = "Target group ARN suffix, e.g. targetgroup/my-tg/73e2d6bc24d8a067"
}

variable "db_instance_id" {
  type        = string
  description = "RDS instance identifier (alarm dimension)"
}
