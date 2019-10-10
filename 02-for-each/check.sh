set -x
aws --region eu-west-1 --profile gal dynamodb list-tables | grep "comms-ks-02"