output "cloudwatch_log_group" {
  description = "ARN of the CloudWatch log groups"
  value       = aws_cloudwatch_log_group.lambda
}