# How to use

```bash
terraform -chdir=infra init -backend-config="bucket=mybucketname"
terraform -chdir=infra plan -parallelism=4
terraform -chdir=infra apply -parallelism=4 -auto-approve
```
