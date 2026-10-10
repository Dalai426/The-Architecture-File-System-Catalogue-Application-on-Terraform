output "topic_arn" {
  description = "ARN of the S3 event notification SNS topic"
  value       = aws_sns_topic.topic.arn
}

output "topic_name" {
  description = "Name of the S3 event notification SNS topic"
  value       = aws_sns_topic.topic.name
}