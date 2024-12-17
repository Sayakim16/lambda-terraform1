output "lambda_function_arn" {
    value = aws_lambda_function.my_lambda.arn
}

output "cloudwatch_event_rule" {
    value = aws_cloudwatch_event_rule.every_five_minutes.name
}

output "s3_bucket_lambda_code" {
    value = aws_s3_bucket.lambda_bucket.bucket
} 

