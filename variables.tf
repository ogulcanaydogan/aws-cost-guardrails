variable "name" {
  description = "Name prefix for resources."
  type        = string
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount."
  type        = number
}

variable "currency" {
  description = "Currency code for the budget."
  type        = string
  default     = "USD"
}

variable "notification_emails" {
  description = "Email addresses to notify about budget and anomalies."
  type        = list(string)
  default     = []
}

variable "create_sns_topic" {
  description = "Whether to create an SNS topic for notifications."
  type        = bool
  default     = true
}

variable "sns_topic_arn" {
  description = "Existing SNS topic ARN to use when create_sns_topic is false."
  type        = string
  default     = null

  validation {
    condition     = var.create_sns_topic || (var.sns_topic_arn != null && var.sns_topic_arn != "")
    error_message = "Provide sns_topic_arn when create_sns_topic is false."
  }
}

variable "enable_anomaly_detection" {
  description = "Whether to enable Cost Anomaly Detection monitor and subscription."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to resources."
  type        = map(string)
  default     = {}
}
