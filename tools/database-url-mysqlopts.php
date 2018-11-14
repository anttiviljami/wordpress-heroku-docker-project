<?php
/**
 * database-url-mysqlopts.php
 *
 * Converts a database url to mysql cli opts and prints them
 */

$database_url = $argv[1];

if( !isset( $database_url ) ) {
  echo "Usage: " . $argv[0] . " \$DATABASE_URL\n";
  exit(1);
}

$url = parse_url($database_url);

$args = [];

if ( isset( $url['user'] ) ) {
  array_push($args, "-u " . $url['user']);
}

if ( isset( $url['pass'] ) ) {
  array_push($args, "-p" . $url['pass']);
}

if ( isset( $url['host'] ) ) {
  array_push($args, "-h " . $url['host']);
}

if ( isset( $url['port'] ) ) {
  array_push($args, "-P " . $url['port']);
}

if ( isset( $url['path'] ) ) {
  array_push($args, ltrim($url['path'], '/'));
}

echo join($args, ' ');
