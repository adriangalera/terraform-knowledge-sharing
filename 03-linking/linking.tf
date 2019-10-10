provider "aws" {
  profile = "gal"
  region = "eu-west-1"
}

variable "app-prefix" {
  type = string
  default = "comms-ks-03"
}

# S3 bucket to place files
resource "aws_s3_bucket" "s3-files-bucket" {
    bucket = "${var.app-prefix}-files-bucket"
    force_destroy = "true"
}
# IAM Role for lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Permission to execute the lambda from the S3
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.download-s3-lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.s3-files-bucket.arn}"
}

# Lambda definition
resource "aws_lambda_function" "download-s3-lambda" {
  filename      = "download-s3-file-lambda.zip"
  function_name = "${var.app-prefix}-download-files-lambda"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "receive-file-s3.handler"
  runtime       = "python3.7"
  depends_on    = ["aws_iam_role_policy_attachment.lambda_logs", "aws_cloudwatch_log_group.example"]
}

# Notify lambda when a file is created in the S3 bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.s3-files-bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.download-s3-lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}

output "s3-bucket-name" {
  value = "${aws_s3_bucket.s3-files-bucket.id}"
}

output "log-group" {
  value = "${aws_cloudwatch_log_group.example.id}"
}

# Prepare a cloudwatch log group and stream for lambda
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.app-prefix}-download-files-lambda"
  retention_in_days = 14
}

# Permission to lambda create log group, etc
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Resource": "${aws_s3_bucket.s3-files-bucket.arn}/*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach the permission to the role
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}