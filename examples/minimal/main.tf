provider "aws" {
  region = "us-east-1"
}

module "cost_guardrails" {
  source = "../.."

  name                  = "example-guardrails"
  monthly_budget_amount = 200
  notification_emails   = ["alerts@example.com"]

  tags = {
    Environment = "example"
  }
}
