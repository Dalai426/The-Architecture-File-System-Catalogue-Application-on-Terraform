variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "topic_name" {
  description = "Name of the S3 event notification SNS topic"
  type        = string
}