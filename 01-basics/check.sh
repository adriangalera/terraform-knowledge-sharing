set -x
aws --region eu-west-1 --profile gal s3 ls | grep "comms-ks"
aws --region eu-west-1 --profile gal dynamodb list-tables | grep "comms-ks"