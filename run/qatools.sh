#!/bin/bash

# install latest composer
export COMPOSER_ALLOW_SUPERUSER=1
export COMPOSER_ALLOW_XDEBUG=0

echo "installing composer..."
curl -# -L https://getcomposer.org/installer | php &> /dev/null
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
echo "installing composer plugin..."
/usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require hirak/prestissimo
