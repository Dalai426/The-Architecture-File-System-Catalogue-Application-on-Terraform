variable "log_group_name" {
  description = "CloudWatch log group for the Lambda function"
  type        = string
}

variable "function_names" {
  type = list(string)
}