# Terraform configuration

To deploy using Terraform, make sure you've prepared Heroku and AWS credentials

For Heroku
```
export HEROKU_API_KEY=
export HEROKU_EMAIL=
```

For AWS, create an IAM user with Administrator rights.
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

Then simply run

```
terraform init
terraform plan
terraform apply
```

The state of Terraform is managed in S3, so it should automatically sync any changes from the remote backend
