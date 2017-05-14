<?php
/*
 * Usually wp-content is inside WordPress core
 * In this project wp-content is moved out of core to be easier to update.
 * Especially with composer.
 └── htdocs
    ├── wp-content
    │   ├── mu-plugins
    │   ├── plugins
    │   ├── themes
    │   └── languages
    ├── wp-config.php
    ├── index.php
    ├── wp-load.php
    └── wordpress # WordPress Core installed by composer
        ├── wp-admin
        ├── index.php
        ├── wp-load.php
        └── ...
 * Some popular plugins have an antipattern to do this:
 *
 * require_once('../../../wp-load.php');
 *
 * They require wp-load.php straight from core usually to have some special ajax functionality.
 *
 * This file is where wp-load.php would typically be and fixes these problems by requiring wp-load.php
 * from where it really is.
 *
 * Author: Onni Hakala / Seravo Oy
 */
require_once( 'wordpress/wp-load.php' );
