locals {
  sns_topic_arn = var.create_sns_topic ? aws_sns_topic.this[0].arn : var.sns_topic_arn
}

resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name = var.name
  tags = var.tags
}

resource "aws_budgets_budget" "monthly" {
  name              = "${var.name}-monthly-budget"
  budget_type       = "COST"
  limit_amount      = var.monthly_budget_amount
  limit_unit        = var.currency
  time_unit         = "MONTHLY"
  time_period_start = "2024-01-01_00:00"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_sns_topic_arns   = [local.sns_topic_arn]
    subscriber_email_addresses  = var.notification_emails
  }

  tags = var.tags
}

resource "aws_ce_anomaly_monitor" "this" {
  count = var.enable_anomaly_detection ? 1 : 0

  name              = "${var.name}-anomaly-monitor"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"

  tags = var.tags
}

resource "aws_ce_anomaly_subscription" "this" {
  count = var.enable_anomaly_detection ? 1 : 0

  name      = "${var.name}-anomaly-subscription"
  frequency = "DAILY"

  monitor_arn_list = [aws_ce_anomaly_monitor.this[0].arn]

  dynamic "subscriber" {
    for_each = var.notification_emails
    content {
      type    = "EMAIL"
      address = subscriber.value
    }
  }

  subscriber {
    type    = "SNS"
    address = local.sns_topic_arn
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = ["100"]
    }
  }

  tags = var.tags
}
