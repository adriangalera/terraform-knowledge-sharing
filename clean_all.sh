base_dir="$(cd "$(dirname "$0")" && pwd)" # Stay gold, bash, stay gold
cd $base_dir/01-basics
terraform destroy -input=false -auto-approve
cd $base_dir/02-for-each
terraform destroy -input=false -auto-approve
cd $base_dir/03-linking
terraform destroy -input=false -auto-approve
cd $base_dir/04-template
terraform destroy -input=false -auto-approve