# Environment

1) One S3 bucket
2) One Lambda function
3) One CloudWatch log group for the Lambda function

The AWS Lambda gets notified when a file is created in S3 and downloads it

Remember to use the deploy script instead of terraform apply!