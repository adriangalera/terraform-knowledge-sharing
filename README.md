
# Terraform Knowledge Sharing

1) What is terraform? Benefits of using it?
    - Tool with DSL
    - Multi-cloud (AWS, Google Cloud, Azure, ...)
    - Infrastructure as code
        - Deploy from local
        - Deploy from pipelines
    - Keep the state of the infra locally (tfstate)
    - Incremental changes
    - `terraform plan`
    - `terraform apply`
    - `terraform destroy`

2) Simple use (01-basics)
    - Create a dynamoDB table and a S3 bucket
2) For each (02-for-each)
    - Create multiple dynamoDB tables and a S3 bucket
3) Linking resources
    - Create resources that interacts between them (S3 -> Lambda)
4) Templates
    - Example of reuse code with templates. Create two docker tasks exactly equals but passing different env vars

## Utils

- Generate a file with random content:
```
dd if=/dev/urandom of=scripts/example-file count=1024 bs=1000
```