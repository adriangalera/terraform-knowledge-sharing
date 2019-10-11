task_definition=$1
cluster=$2
subnet=$3
if [ -z $task_definition ]
then
    echo "run-task <task_definition> <cluster> <subnet>"
    exit 1
fi
if [ -z $cluster ]
then
    echo "run-task <task_definition> <cluster> <subnet>"
    exit 1
fi
if [ -z $subnet ]
then
    echo "run-task <task_definition> <cluster> <subnet>"
    exit 1
fi

set -x
aws --region eu-west-1 --profile gal ecs run-task --task-definition $task_definition --cluster $cluster --network-configuration "awsvpcConfiguration={subnets=[$subnet],assignPublicIp=ENABLED}" --launch-type FARGATE