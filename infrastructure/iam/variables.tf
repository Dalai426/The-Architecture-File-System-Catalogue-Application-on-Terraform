variable "project_name" {
  description = "Project name used to name IAM resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
  default     = {}
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}