#!/bin/bash
# NOTE: Run this only from project root!

# Run all test commands and if one fails, exit non-zero return code
EXIT_STATUS=0

if [ ! -f .env.test ]; then
    # In Travis CI
    echo "Loading env vars from .env.test.sample. Assuming secrets have been defined elsewhere, e.g. in Travis CI project settings.."
    source .env.test.sample || EXIT_STATUS=$?
else
    # When running on local machine
    echo "Loading env vars from .env.test. Assuming all needed env variables have been defined there.."
    source .env.test || EXIT_STATUS=$?
fi

# Update composer and install project
composer self-update
composer install

# Install WordPress coding standards ruleset for WordPress if not yet installed
[[ -f $HOME/wpcs/composer.json ]] || composer create-project wp-coding-standards/wpcs:dev-master --no-dev $HOME/wpcs

echo -e "\n------ Linting code..\n"
$HOME/wpcs/vendor/bin/phpcs --extensions=php --standard=./phpcs.xml -n -p . || EXIT_STATUS=$?

exit $EXIT_STATUS

