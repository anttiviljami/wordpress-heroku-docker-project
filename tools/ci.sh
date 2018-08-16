#!/bin/bash
# NOTE: Run this only from project root!

DEBIAN_FRONTEND=noninteractive

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

# Run npm install
npm install

# Run composer install
composer install --no-interaction

echo -e "\n------ Linting code...\n"
npm run lint || EXIT_STATUS=$?

exit $EXIT_STATUS

