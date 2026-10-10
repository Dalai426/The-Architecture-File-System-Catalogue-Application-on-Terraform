data "archive_file" "lambda_zip" {
  for_each = var.lambda_functions

  type        = "zip"
  source_dir  = each.value.source_dir
  output_path = "${path.root}/dist/${each.key}.zip"
}

resource "aws_lambda_function" "app" {
  for_each = var.lambda_functions

  function_name = each.key
  role          = each.value.role_arn
  handler       = each.value.handler
  runtime       = each.value.runtime

  filename         = data.archive_file.lambda_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256

  logging_config {
    log_format = "Text"
    log_group  = each.value.log_group_name
  }
}