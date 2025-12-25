output "budget_name" {
  description = "Name of the AWS Budget."
  value       = aws_budgets_budget.monthly.name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for notifications."
  value       = local.sns_topic_arn
}

output "anomaly_monitor_arn" {
  description = "ARN of the Cost Anomaly Detection monitor (when enabled)."
  value       = try(aws_ce_anomaly_monitor.this[0].arn, null)
}
