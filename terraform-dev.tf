# Random password for database
resource "random_id" "dev" {
  keepers = {
    project_name = "${var.project_name}"
  }
  byte_length = 16
}

# RDS MariaDB instance
resource "aws_db_instance" "dev" {
  engine = "mariadb"
  identifier = "${var.project_name}-dev"
  allocated_storage = 5
  engine_version = "10.1.23"
  instance_class = "db.t2.micro"
  name = "wordpress"
  username = "wordpress"
  password = "${random_id.dev.hex}"
  publicly_accessible = true
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  final_snapshot_identifier = "${var.project_name}-dev"
}

# IAM user for S3 bucket
resource "aws_iam_user" "dev" {
  name = "${var.project_name}-dev-user"
}

# Access keys for IAM user
resource "aws_iam_access_key" "dev" {
  user = "${aws_iam_user.dev.name}"
}

# S3 bucket for uploads
resource "aws_s3_bucket" "dev" {
  bucket = "${var.project_name}-dev-uploads"
  acl = "public-read"
  force_destroy = "true"
}

# Grant full access to the bucket
resource "aws_s3_bucket_policy" "dev" {
  bucket = "${aws_s3_bucket.dev.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.dev.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.dev.arn}",
        "${aws_s3_bucket.dev.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [ "s3:GetObject" ],
      "Resource": [
        "${aws_s3_bucket.dev.arn}",
        "${aws_s3_bucket.dev.arn}/*"
      ]
    }
  ]
}
EOF
}

# Heroku App
resource "heroku_app" "dev" {
  name = "${var.project_name}-dev"
  region = "eu"
  buildpacks = [
    "heroku/php",
    "heroku/nodejs"
  ]
  config_vars {
    WP_ENV = "dev"
    DATABASE_URL = "mysql://wordpress:${random_id.dev.hex}@${aws_db_instance.dev.address}/wordpress"
    S3_UPLOADS_BUCKET = "${aws_s3_bucket.dev.id}"
    S3_UPLOADS_KEY = "${aws_iam_access_key.dev.id}"
    S3_UPLOADS_SECRET = "${aws_iam_access_key.dev.secret}"
    S3_UPLOADS_REGION = "${var.aws_region}"
  }
}

# Heroku Redis
resource "heroku_addon" "redis-dev" {
  app = "${heroku_app.dev.name}"
  plan = "heroku-redis:hobby-dev"
}

# Heroku Papertrail
resource "heroku_addon" "papertrail-dev" {
  app = "${heroku_app.dev.name}"
  plan = "papertrail:choklad"
}

# Outputs
output "heroku git remote dev" { value = "${heroku_app.dev.git_url}" }

