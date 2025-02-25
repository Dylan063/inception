<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'mot_de_passe' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '[18eq!lS+H;z1ugwWgXiuh).n0))@xK9HQHwRYON6w2NSQ.e0:<dke}}aqmxtQ0-' );
define( 'SECURE_AUTH_KEY',   '`.]D-b]Y(R({zB.?:W+QWZB#XJsEA!uI+A>-5 R2=?yCtv[aH^E9~HTl{gh2vA%r' );
define( 'LOGGED_IN_KEY',     '4mWT{^*`IKm({^T*txz)4`U5I39ZHhbfiXLL9E^F AD/nrMFz1[Z#8lt[M/|6syV' );
define( 'NONCE_KEY',         'L]&0[4z1j*j:QVwRvSbX_|O/&Yap%=3G@+=coog3GqYD1k99d)#1NZ:sOB_{@e>E' );
define( 'AUTH_SALT',         'f10o+)vjD5n lZ&/-xYYf|s34l.syJTszUol{6jE.>y*,:92.f=XA,@N$>xVXt]o' );
define( 'SECURE_AUTH_SALT',  '+Y]f3sZc2olx|:$$b~L jPTZiTdy8%(x#`:HYF^{mNoL5@3p`-8 S0n?-Z`R<Zie' );
define( 'LOGGED_IN_SALT',    '$D58g6W(JK1k]==bjniCJ*U:Wp_kO9+C.8K,IYVq_);|7WD{)3%]:;o]&|:;FM=I' );
define( 'NONCE_SALT',        'C?s,XwOOj=@YiC}Bfk{wWXbqhN5(X2E65i/N_W:)$g^FVk(WD8`2?cAqdwn`t+n5' );
define( 'WP_CACHE_KEY_SALT', 'x}izNv9?M#y<T8_(W *+5?5/M:bvm^DI5Mv;l]^Df6!XcwUen*ZSGj]?XzB^YP%|' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
