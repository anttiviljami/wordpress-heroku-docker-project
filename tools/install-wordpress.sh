#!/bin/bash
set -e

if `wp core is-installed`; then
  echo "----> Error: WordPress is already installed."
  exit 1;
fi

WP_CONTENT_DIR=/app/user/htdocs/wp-content

# deactivate object-cache
mv $WP_CONTENT_DIR/object-cache.php $WP_CONTENT_DIR/object-cache.php.bak &> /dev/null || true

# install core
wp core install \
  --url=http://localhost:$PORT \
  --admin_user=docker \
  --admin_password=docker \
  --admin_email=docker@wp.co \
  --prompt=title \
  --skip-email

# activate all installed plugins
wp plugin activate --all

# reactivate object-cache
mv $WP_CONTENT_DIR/object-cache.php.bak $WP_CONTENT_DIR/object-cache.php &> /dev/null || true

# flush cache
wp cache flush

echo "----> WordPress installed succesfully!"
exit 0;
