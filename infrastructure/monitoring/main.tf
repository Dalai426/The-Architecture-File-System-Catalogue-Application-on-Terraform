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