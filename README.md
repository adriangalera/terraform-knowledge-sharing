
# Terraform Knowledge Sharing

1) What is terraform? Benefits of using it?
    - tfstate
    - plan
    - apply 
    - destroy
    - multi-cloud
    - Infrastructure as code
        - Deploy from local
        - Deploy from pipelines
2) Simple use (01-basics)
    - Create a dynamoDB table and a S3 bucket
2) For each (02-for-each)
    - Create multiple dynamoDB tables and a S3 bucket
3) Linking resources
    - Create resources that interacts between them (S3 -> Lambda)
4) Templates
    - Example of reuse code with templates
5) Advanced use
    - Networking

## Utils

- Generate a file with random content:
```
dd if=/dev/urandom of=scripts/example-file count=1024 bs=1000
```