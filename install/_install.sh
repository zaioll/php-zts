#!/bin/bash

export install_base=/usr
mkdir /info

/install/pre-install.sh
/install/packages.sh
/install/php.sh
/install/php-parallel.sh
/install/php-decimal.sh
/install/php-xdebug.sh
/install/php-memcached.sh
/install/php-mongodb.sh
/install/php-redis.sh
/install/post-install.sh
