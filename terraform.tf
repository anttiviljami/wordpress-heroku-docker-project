variable "project_name" {}
variable "aws_region" { default = "eu-west-1" }

# AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
provider "aws" { region = "${var.aws_region}" }

# HEROKU_API_KEY, HEROKU_EMAIL
provider "heroku" {}

# Store Terraform state in S3 (this must be prepared in advance)
terraform {
  backend "s3" {
    bucket = "wp-terraform-backend"
    key = "wp/terraform.tfstate"
    region = "eu-west-1"
  }
}

# AWS security group for public database access
resource "aws_security_group" "default" {
  name = "rds0"
  description = "public RDS security group"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
