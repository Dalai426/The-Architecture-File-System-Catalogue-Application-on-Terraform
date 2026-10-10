output "lambda_function_names" {
  description = "Names of the deployed Lambda functions"

  value = {
    for name, function in aws_lambda_function.app :
    name => function.function_name
  }
}

output "lambda_function_arns" {
  description = "ARNs of the deployed Lambda functions"

  value = {
    for name, function in aws_lambda_function.app :
    name => function.arn
  }
}

output "lambda_invoke_arns" {
  description = "Invoke ARNs of the deployed Lambda functions"

  value = {
    for name, function in aws_lambda_function.app :
    name => function.invoke_arn
  }
}