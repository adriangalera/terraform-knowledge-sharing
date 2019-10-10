bucket=$1
file=$2

base_dir="$(cd "$(dirname "$0")" && pwd)" # Stay gold, bash, stay gold

if [ -z $bucket ]
then
    echo "upload-file.sh <bucket> <file>"
    exit 1
fi

if [ -z $file ]
then
    echo "upload-file.sh <bucket> <file>"
    exit 1
fi
set -x
aws --profile gal s3 cp $file s3://$bucket
sleep 5
aws --profile gal s3 rm s3://$bucket/$file
