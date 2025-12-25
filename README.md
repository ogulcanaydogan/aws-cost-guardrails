# aws-cost-guardrails

Terraform module to provision AWS Cost Guardrails:

- Monthly AWS Budgets cost budget
- SNS notifications (create or reuse a topic)
- Optional Cost Anomaly Detection monitor + subscription

## Usage

```hcl
module "cost_guardrails" {
  source = "../.."

  name                  = "example-guardrails"
  monthly_budget_amount = 250
  notification_emails   = ["finance@example.com"]

  tags = {
    Environment = "dev"
  }
}
```

### Reuse an existing SNS topic

```hcl
module "cost_guardrails" {
  source = "../.."

  name                  = "example-guardrails"
  monthly_budget_amount = 500

  create_sns_topic = false
  sns_topic_arn    = "arn:aws:sns:us-east-1:123456789012:cost-alerts"
}
```

### Enable anomaly detection

```hcl
module "cost_guardrails" {
  source = "../.."

  name                     = "example-guardrails"
  monthly_budget_amount    = 1000
  enable_anomaly_detection = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for resources. | `string` | n/a | yes |
| monthly_budget_amount | Monthly budget amount. | `number` | n/a | yes |
| currency | Currency code for the budget. | `string` | `"USD"` | no |
| notification_emails | Email addresses to notify about budget and anomalies. | `list(string)` | `[]` | no |
| create_sns_topic | Whether to create an SNS topic for notifications. | `bool` | `true` | no |
| sns_topic_arn | Existing SNS topic ARN to use when create_sns_topic is false. | `string` | `null` | no |
| enable_anomaly_detection | Whether to enable Cost Anomaly Detection monitor and subscription. | `bool` | `false` | no |
| tags | Tags applied to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| budget_name | Name of the AWS Budget. |
| sns_topic_arn | SNS topic ARN for notifications. |
| anomaly_monitor_arn | ARN of the Cost Anomaly Detection monitor (when enabled). |

## Notes

- Budget notifications are configured at 100% of the monthly budget using actual spend.
- Anomaly detection uses a daily subscription with a $100 absolute impact threshold.
