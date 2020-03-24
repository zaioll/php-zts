#!/bin/bash

export INSTALL_BASE=/usr
mkdir /info

/install/pre-install.sh
/install/packages.sh
/install/php.sh
/install/php-decimal.sh
/install/php-pthreads.sh
/install/php-xdebug.sh
/install/php-memcached.sh
/install/php-mongodb.sh
/install/php-redis.sh
##/install/php-phalcon.sh
/install/post-install.sh
