data "aws_caller_identity" "current" {}

locals {
  s3_bucket_name = lower(
    "${var.project_name}-${data.aws_caller_identity.current.account_id}-${var.region}-s3"
  )
  log_group_name = lower(
    "${var.project_name}-${data.aws_caller_identity.current.account_id}-${var.region}-monitoring-log-group"
  )
}

module "storage" {
  source = "./storage"
  // variables
  s3_bucket_name = local.s3_bucket_name
}

module "iam" {
  source = "./iam"
  // variables
  project_name = var.project_name
  tags = {
    Project   = var.project_name
    Purpose   = "ProcessUploadedFiles"
    ManagedBy = "Terraform"
  }
  bucket_arn = module.storage.bucket_arn
}

module "functions" {
  source = "./functions"
  lambda_functions = {
    "${var.project_name}-handle-s3-events" = {
      handler        = "lambda_function.lambda_handler"
      runtime        = "python3.12"
      log_group_name = local.log_group_name
      source_dir     = "${path.root}/../backend/functions/catalog_function"
      role_arn       = module.iam.lambda_role_arn
    }
  }
}

module "broker" {
  source = "./broker"
  // variables
  bucket_arn = module.storage.bucket_arn
  topic_name = "${var.project_name}-s3-event-notification-topic"
}

module "monitoring" {
  source         = "./monitoring"
  log_group_name = local.log_group_name
  function_names = [
    "${var.project_name}-handle-s3-events"
  ]
}


