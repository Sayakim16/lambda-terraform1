provider "aws" {
    region = "us-east-1"
}

# S3 bucket for Lambda function and Terraform state 
resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "my-lambda-univer-bucket"
}

# Upload Lambda Function ZIP file to S3
resource "aws_s3_object" "lambda_zip" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key    = "lambda_function.zip"
    source = "lambda_function/lambda_function.zip"  # Local Path to Lambda ZIP file
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

# Attach AWSLambdaBasicExecutionRole to Lambda role resource 
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function definition
resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
    s3_key        = aws_s3_object.lambda_zip.key
    handler       = "index.handler"
    runtime       = "nodejs18.x"
    role          = aws_iam_role.lambda_role.arn
}

# CloudWatch Event Rule for cron job (every_5_minutes)
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
    name                = "every_five_minutes"
    schedule_expression = "cron(*/5 * * * ? *)" #Run every_5_minutes
}

# Event Target: Connect Cloud watch Rule to Lambda resource 
resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.every_five_minutes.name
    target_id = "lambda"
    arn       = aws_lambda_function.my_lambda.arn 
}

# Lambda Permission: Allow CloudWatch to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}

# Terraform Backend Configuration
terraform {
    backend "s3" {
        bucket = "my-lambda-univer-bucket"
        key    = "terraform/state"
        region = "us-east-1"
    }
}
