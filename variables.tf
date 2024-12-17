variable "region" {
    description = "The AWS region to deploy to"
    type        = string
    default     = "us-east-1"
}

variable "bucket_name" {  
    description = "The name of the S3 bucket"
    type        = string
    default     = "my-lambda-univer-bucket"
}

variable "lambda_function_zip" {
    description = "The path to the lambda function zip file"
    type        = string
    default     = "path/to/your/lambda_function.zip"
}

variable "lambda_role_name" {
    description = "The name of the IAM role for Lambda"
    type        = string
    default     = "lambda_role"
}

variable "lambda_function_name" {
    description = "The name of the Lambda function"
    type        = string
    default     = "my_lambda_function"
}

variable "schedule_expression" {
    description = "The schedule expression for CloudWatch event rule"
    type        = string
    default     = "cron(*/5 * * * ? *)"
}

variable "my-lambda-univer-bucket" {
    description = "The name of the S3 bucket for Terraform state"
    type        = string
    default     = "my-lambda-univer-bucket"
}

variable "terraform_state_key" {
    description = "The key for the Terraform state in S3"
    type        = string
    default     = "terraform/state"
}