resource "aws_cloudwatch_log_group" "lambda" {
  name              = var.log_group_name
  retention_in_days = 3
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  for_each = toset(var.function_names)

  alarm_name        = "${each.value}-errors"
  alarm_description = "Lambda function has reported errors"

  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    FunctionName = each.value
  }

  treat_missing_data = "notBreaching"
}

resource "aws_budgets_budget" "account_monthly" {
  name         = "account-monthly-cost-budget"
  budget_type  = "COST"
  limit_amount = "4"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_notification_email]
  }
}