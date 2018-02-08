#!/bin/sh

set -e

USAGE="migrate-db.sh <source env> <target env>"

# Check args
if [ -z "$1" ] || [ -z "$2" ]; then
  echo $USAGE >&2;
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Get siteurls
if [[ $1 == 'local' ]]; then
  SOURCE_URL=`docker-compose run -T --rm shell bash -c ". .env && wp option get siteurl"`;
else
  SOURCE_URL=`heroku run wp option get siteurl -r $1`;
fi

# Get siteurls
if [[ $2 == 'local' ]]; then
  TARGET_URL=`docker-compose run -T --rm shell bash -c ". .env && wp option get siteurl"`;
else
  TARGET_URL=`heroku run wp option get siteurl -r $2`;
fi

echo "You are about to overwrite the database for $SOURCE_URL with contents from $TARGET_URL";
read -p "Are you sure you want to do this? (y/n)" -n 1 -r;
echo "";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Pipe search & replaced mysqldump from source to target
if [[ $1 == 'local' ]]; then
  EXPORT_CMD="docker-compose run -T --rm shell bash -c '. .env && wp search-replace $SOURCE_URL $TARGET_URL --export'"
else
  EXPORT_CMD="heroku run --no-tty 'wp search-replace $SOURCE_URL $TARGET_URL --export' -r $1"
fi

if [[ $2 == 'local' ]]; then
  IMPORT_CMD="docker-compose run --rm shell bash -c '. .env && wp db import -'"
else
  IMPORT_CMD="heroku run --no-tty 'wp db import -' -r $2"
fi

eval "$EXPORT_CMD | $IMPORT_CMD"

echo "Success!"

