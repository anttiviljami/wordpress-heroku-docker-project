#!/bin/bash

set -e

USAGE="backup-db.sh <source env>"


# Check args
if [ -z "$1" ]; then
  echo $USAGE >&2;
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

if [[ $1 == 'local' ]]; then
  EXPORT_CMD="docker-compose run -T --rm shell bash -c '. .env && mysqldump \$(php tools/database-url-mysqlopts.php \$DATABASE_URL) --quick --single-transaction --extended-insert'"
else
  EXPORT_CMD="heroku run --no-tty 'mysqldump \$(php tools/database-url-mysqlopts.php \$DATABASE_URL) --quick --single-transaction --extended-insert' -r $1"
fi

BACKUP_TARGET=backup-$1-$(date +"%Y-%m-%d").sql

eval "$EXPORT_CMD > $BACKUP_TARGET"
echo "Success! Backed up to file $BACKUP_TARGET"

