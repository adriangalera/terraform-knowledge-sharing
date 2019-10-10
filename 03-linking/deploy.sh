#Make a zip with the lambda contents
zip -r -9 -j download-s3-file-lambda.zip lambda/*.py
terraform apply