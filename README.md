AWS Lambda with Cron Trigger Using Terraform
This project sets up an AWS Lambda function triggered every 5 minutes via a CloudWatch cron job. The Lambda code and Terraform state are stored in S3 buckets.

Features
AWS Lambda: Deploys a Node.js Lambda function using code from an S3 bucket.
Cron Trigger: CloudWatch Events schedule the Lambda to run every 5 minutes.
S3 Buckets: Store the Lambda code (lambda_function.zip) and Terraform state.
IAM Role: Creates the required IAM role for Lambda execution.
Prerequisites
Ensure the following tools are installed and configured:

Terraform: Install Terraform
AWS CLI: Configure credentials using:
bash
Copy code
aws configure
Lambda Code: Package your Node.js Lambda code:
bash
Copy code
zip lambda_function.zip index.js
S3 Buckets:
Replace my-lambda-code-bucket for Lambda code.
Replace my-terraform-state-bucket for Terraform state.
Project Structure
plaintext
Copy code
.
├── main.tf               # Terraform configuration
├── lambda_function.zip   # Zipped Lambda function
└── README.md             # Documentation
Usage
1. Clone the Repository
bash
Copy code
git clone https://github.com/Sayakim16/Universitytask.git
cd Universitytask
2. Update Configuration
Edit main.tf:

Replace path/to/your/lambda_function.zip with your ZIP file path.
Replace S3 bucket names (my-lambda-code-bucket and my-terraform-state-bucket).
3. Deploy Infrastructure
Initialize, plan, and apply Terraform:

bash
Copy code
terraform init
terraform plan
terraform apply
Type yes to confirm.

4. Verify Deployment
S3: Check the Lambda ZIP file in the bucket.
AWS Lambda: Verify the function in the AWS console.
CloudWatch: Ensure the rule triggers every 5 minutes.
How It Works
S3: Lambda code is stored in my-lambda-code-bucket.
IAM Role: Terraform creates the necessary permissions for Lambda.
CloudWatch: A cron rule (cron(*/5 * * * ? *)) triggers the Lambda every 5 minutes.
Terraform State: Stored in my-terraform-state-bucket for consistency.
Clean Up
Destroy the infrastructure to avoid charges:

bash
Copy code
terraform destroy
Type yes to confirm.

Troubleshooting
Missing Permissions: Ensure AWS credentials have access to S3, Lambda, IAM, and CloudWatch.
Lambda Errors: Check CloudWatch Logs for errors. Verify the runtime and handler settings.
Cron Issues: Confirm the CloudWatch rule is active and linked to Lambda.
Notes
Replace all bucket names in main.tf with unique names.
The cron expression cron(0/5 * * * ? *) means every 5 minutes.
Modify the Lambda function logic in lambda.py as needed.

Conclusion
This project automates AWS resource creation using Terraform and deploys a Lambda function triggered every 5 minutes. It’s a great example of combining Infrastructure as Code (IaC) with serverless compute.


