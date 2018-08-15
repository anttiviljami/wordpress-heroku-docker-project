#!/bin/bash

set -e

USAGE="migrate-db.sh <source env> <target env>"

DUMP_HEADER="
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
"

DUMP_FOOTER="
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
"

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

echo "You are about to overwrite the database for $TARGET_URL with contents from $SOURCE_URL";
read -p "Are you sure you want to do this? (y/n)
";
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1;
fi

# Pipe search & replaced mysqldump from source to target
if [[ $1 == 'local' ]]; then
  EXPORT_CMD="docker-compose run -T --rm shell bash -c '. .env && wp search-replace $SOURCE_URL $TARGET_URL --export --all-tables'"
else
  EXPORT_CMD="heroku run --no-tty 'wp search-replace $SOURCE_URL $TARGET_URL --export --all-tables' -r $1"
fi

if [[ $2 == 'local' ]]; then
  IMPORT_CMD="docker-compose run --rm shell bash -c '. .env && wp db import -'"
else
  IMPORT_CMD="heroku run --no-tty 'wp db import -' -r $2"
fi

eval "(echo -e '$DUMP_HEADER' && $EXPORT_CMD && echo -e '$DUMP_FOOTER') | $IMPORT_CMD"

# Flush cache in target
if [[ $2 == 'local' ]]; then
  docker-compose run --rm shell bash -c ". .env && wp cache flush"
else
  heroku run wp cache flush -r $2
fi

echo "Success!"

