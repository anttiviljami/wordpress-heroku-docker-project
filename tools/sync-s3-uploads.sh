#!/bin/sh

set -e

USAGE="sync-s3-uploads.sh <source env> <target env>"

# Check args
if [ -z "$1" ] || [ -z "$2" ]; then
  echo $USAGE >&2;
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Get bucket urls
SOURCE_BUCKET=`heroku config:get S3_UPLOADS_BUCKET -r $1`;
TARGET_BUCKET=`heroku config:get S3_UPLOADS_BUCKET -r $2`;

echo "You are about to copy all files from the bucket $SOURCE_BUCKET to $TARGET_BUCKET";
read -p "Are you sure you want to do this? (y/n)" -n 1 -r;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Use aws-cli to synchronize buckets
aws s3 sync s3://$SOURCE_BUCKET s3://$TARGET_BUCKET
echo "Success!"

