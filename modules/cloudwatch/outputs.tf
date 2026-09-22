output "sns_topic_arn" {
  description = "SNS topic every alarm publishes to"
  value       = aws_sns_topic.alerts.arn
}
