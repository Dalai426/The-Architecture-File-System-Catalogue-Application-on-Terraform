variable "lambda_functions" {
  description = "Lambda functions to deploy"

  type = map(object({
    handler        = string
    runtime        = string
    source_dir     = string
    log_group_name = string
    role_arn       = string
  }))
}