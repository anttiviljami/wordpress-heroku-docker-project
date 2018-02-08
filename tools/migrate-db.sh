#!/bin/sh

set -e

USAGE="migrate-db.sh <source env> <target env>"

# Check args
if [ -z "$1" ] || [ -z "$2" ]; then
  echo $USAGE >&2;
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Get siteurls
SOURCE_URL=`heroku run wp option get siteurl -r $1`;
TARGET_URL=`heroku run wp option get siteurl -r $2`;

echo "You are about to overwrite the database for $1 ($SOURCE_URL) with contents from $2 ($TARGET_URL)";
read -p "Are you sure you want to do this? (y/n)" -n 1 -r;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Pipe search & replaced mysqldump from source to target
heroku run --no-tty "wp search-replace $SOURCE_URL $TARGET_URL --export" -r $1 | heroku run --no-tty "wp db import -" -r $2

echo "Success!"

