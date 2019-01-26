<?php
/**
 * This file contains WordPress config and replaces the usual wp-config.php
 */
$root_dir    = dirname( __DIR__ );
$webroot_dir = $root_dir . '/htdocs';

/**
 * Expose global env() function from oscarotero/env
 */
Env::init();

/**
 * Use Dotenv to set required environment variables and load .env file in root
 * Most of ENV are set from docker environment
 */
$dotenv = new Dotenv\Dotenv( $root_dir );
if ( file_exists( $root_dir . '/.env' ) ) {
  $dotenv->load();
}

/**
 * Set up our global environment constant
 * Default: development
 */
define( 'WP_ENV', strtolower( env( 'WP_ENV' ) ) ?: 'development' );

/**
 * Set URLs for WP
 * SERVER_NAME is used because WordPress uses it by default in some contexts and we
 * don't want to have million different variables to set.
 *
 * Deduct them from request parameters if developer didn't set the SERVER_NAME.
 *
 * We can always just use nginx to redirect aliases to canonical url
 * This helps changing between dev->stage->production
 */
if ( env( 'WP_HOME' ) && env( 'WP_SITEURL' ) ) {
  define( 'WP_HOME', env( 'WP_HOME' ) );
  define( 'WP_SITEURL', env( 'WP_SITEURL' ) );
}

/**
 * WordPress needs $_SERVER['HTTPS'] for is_ssl() in many places
 */
if ( ! isset( $_SERVER['HTTPS'] ) ) {
  $_SERVER['HTTPS'] = isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] )
    && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https' ? 'on' : 'off';
}

/**
 * DB settings
 */
// PHPCS doesn't like parse_url because wp_parse_url is preferred
//@codingStandardsIgnoreStart
$database_url = parse_url( env( 'DATABASE_URL' ) );
define( 'DB_NAME', trim( $database_url['path'], '/' ) );
define( 'DB_USER', trim( $database_url['user'] ) );
define( 'DB_PASSWORD', trim( $database_url['pass'] ) );
define( 'DB_HOST', trim( $database_url['host'] ) );
define( 'DB_PORT', trim( $database_url['port'] ) );
define( 'DB_CHARSET', env( 'DB_CHARSET' ) ?: 'utf8mb4' );
define( 'DB_COLLATE', env( 'DB_COLLATE' ) ?: 'utf8mb4_swedish_ci' );
$table_prefix = env( 'DB_PREFIX' ) ?: 'wp_';
//@codingStandardsIgnoreEnd

// PHPCS doesn't like parse_url because wp_parse_url is preferred
//@codingStandardsIgnoreStart
$redis_url = parse_url( env( 'REDIS_URL' ) );
//@codingStandardsIgnoreEnd
if ( isset( $redis_url['host'] ) ) {
  define( 'WP_REDIS_USER', trim( $redis_url['user'] ) );
  define( 'WP_REDIS_PASSWORD', trim( $redis_url['pass'] ) );
  define( 'WP_REDIS_HOST', trim( $redis_url['host'] ) );
  define( 'WP_REDIS_PORT', trim( $redis_url['port'], '/' ) );
}

/**
 * Authentication Unique Keys and Salts
 */
define( 'AUTH_KEY', env( 'AUTH_KEY' ) );
define( 'SECURE_AUTH_KEY', env( 'SECURE_AUTH_KEY' ) );
define( 'LOGGED_IN_KEY', env( 'LOGGED_IN_KEY' ) );
define( 'NONCE_KEY', env( 'NONCE_KEY' ) );
define( 'AUTH_SALT', env( 'AUTH_SALT' ) );
define( 'SECURE_AUTH_SALT', env( 'SECURE_AUTH_SALT' ) );
define( 'LOGGED_IN_SALT', env( 'LOGGED_IN_SALT' ) );
define( 'NONCE_SALT', env( 'NONCE_SALT' ) );

/**
 * S3 Uploads Config
 */
define( 'S3_UPLOADS_BUCKET', env( 'S3_UPLOADS_BUCKET' ) );
define( 'S3_UPLOADS_KEY', env( 'S3_UPLOADS_KEY' ) );
define( 'S3_UPLOADS_SECRET', env( 'S3_UPLOADS_SECRET' ) );
define( 'S3_UPLOADS_REGION', env( 'S3_UPLOADS_REGION' ) );

/**
 * Custom Settings
 */
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define( 'DISABLE_WP_CRON', env( 'DISABLE_WP_CRON' ) ?: false );
define( 'DISALLOW_FILE_EDIT', true );
define( 'FS_METHOD', 'direct' );

/**
 * Only keep the last 30 revisions of a post. Having hundreds of revisions of
 * each post might cause sites to slow down, sometimes significantly due to a
 * massive, and usually unecessary bloating the wp_posts and wp_postmeta tables.
 */
define( 'WP_POST_REVISIONS', env( 'WP_POST_REVISIONS' ) ?: 30 );

/**
 * Define memory limit so that wp-cli can use more memory than the default 40M
 */
define( 'WP_MEMORY_LIMIT', env( 'PHP_MEMORY_LIMIT' ) ?: '128M' );

/**
 * Load custom configs according to WP_ENV environment variable
 */
$env_config = __DIR__ . '/env/' . WP_ENV . '.php';

if ( file_exists( $env_config ) ) {
  include_once $env_config;
}

/**
 * Bootstrap WordPress
 */
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', $webroot_dir . '/wordpress/' );
}

/**
 * Remove temporary variables from the global context
 */
unset( $root_dir, $webroot_dir, $env_config, $database_url );
