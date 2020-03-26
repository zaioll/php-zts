#!/bin/bash

# install latest composer
curl -# -L https://getcomposer.org/installer | php &> /dev/null
if [ -e composer.phar ];then
    export COMPOSER_ALLOW_SUPERUSER=1
    export COMPOSER_ALLOW_XDEBUG=0

    echo "installing composer..."
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer

    echo "installing composer plugin..."
    /usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require hirak/prestissimo
else
    echo "Falha ao instalar composer..."
fi