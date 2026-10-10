variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

variable "topic_name" {
  description = "Name of the S3 event notification SNS topic"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}
