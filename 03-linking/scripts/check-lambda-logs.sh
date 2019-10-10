
loggroup=$1
if [ -z $loggroup ]
then
    echo "check-lambda-logs.sh <log group>"
    exit 1
fi
set -x
log_stream=`aws --region eu-west-1 --profile gal logs describe-log-streams --log-group-name $loggroup | jq -r ".logStreams[0].logStreamName"`
aws --region eu-west-1 --profile gal logs  get-log-events --log-group-name $loggroup --log-stream-name $log_stream