#!/bin/bash

set -e

USAGE="backup-db.sh <source env>"
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BACKUP_TARGET=backup-$1-$(date +"%Y-%m-%d").sql


# Check args
if [ -z "$1" ]; then
  echo $USAGE >&2;
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

if [[ $1 == 'local' ]]; then
  DB_URL=$DATABASE_URL
else
  echo "Getting DATABASE_URL from heroku..."
  DB_URL=$(heroku config:get DATABASE_URL -r $1)
fi

CONNECTION_OPTS=$(php $DIRNAME/database-url-mysqlopts.php $DB_URL)
EXPORT_CMD="(
mysqldump $CONNECTION_OPTS \
  --quick \
  --single-transaction \
  --extended-insert \
  --ignore_table=wordpress.cache_products 2> /dev/null && \
mysqldump --no-data $CONNECTION_OPTS cache_products 2> /dev/null
)"

echo "Backing up to database to file $BACKUP_TARGET with mysqldump..."
eval "$EXPORT_CMD > $BACKUP_TARGET"
echo "Success! Backed up to file $BACKUP_TARGET"

