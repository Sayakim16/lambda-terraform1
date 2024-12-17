provider "aws" {
    region = "us-east-1"
}

# S3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "my-lambda-univer-bucket"
}

# S3 object (lambda function zip file)
resource "aws_s3_object" "lambda_zip" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key    = "lambda_function.zip"
    source = "lambda_function/lambda_function.zip"  # Path to your ZIP file
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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
    s3_key        = aws_s3_object.lambda_zip.key
    handler       = "index.handler"
    runtime       = "nodejs18.x"
    role          = aws_iam_role.lambda_role.arn
}

# CloudWatch rule and target
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
    name                = "every_five_minutes"
    schedule_expression = "cron(*/5 * * * ? *)" 
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule      = aws_cloudwatch_event_rule.every_five_minutes.name
    target_id = "lambda"
    arn       = aws_lambda_function.my_lambda.arn 
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda.function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}

terraform {
    backend "s3" {
        bucket = "my-lambda-univer-bucket"
        key    = "terraform/state"
        region = "us-east-1"
    }
}
