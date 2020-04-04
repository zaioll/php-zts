#!/bin/bash

# install latest composer
printf "\n%20s: try download composer...\n"
curl \
    --progress-bar \
    --max-time 60 \
    --retry-max-time 60 \
    --retry 5 \
    --location https://getcomposer.org/installer | php &> /dev/null
if [ -e composer.phar ];then
    mv composer.phar /usr/local/bin/composer
    if [ -e /usr/local/bin/composer ];then
        chmod +x /usr/local/bin/composer
        printf "\n%20s: Composer installed at '/usr/local/bin/composer'."
    else
        printf "\n%20s: Composer install failed!"
    fi

    printf "\n%20s: Setting COMPOSER_ALLOW_SUPERUSER env var to '1'."
    export COMPOSER_ALLOW_SUPERUSER=1
    printf "\n%20s: Setting COMPOSER_ALLOW_XDEBUG env var to '0'."
    export COMPOSER_ALLOW_XDEBUG=0

    printf "\n%20s: Installing 'prestissimo' composer plugin...\n"
    /usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require hirak/prestissimo -v
    printf "\n%20s: Installing 'phpbench'...\n"
    /usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require phpbench/phpbench @dev -v
else
    printf "\n%20s: Composer download failed..."
fi

printf "\n%20s: try to install phive..."
wget -O phive.phar https://phar.io/releases/phive.phar
wget -O phive.phar.asc https://phar.io/releases/phive.phar.asc
gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79
gpg --verify phive.phar.asc phive.phar

if [ -e phive.phar ]; then
    chmod +x phive.phar
    mv phive.phar /usr/local/bin/phive
    printf "\n%20s: Phive installed at '/usr/local/bin/phive'."
else
    printf "\n%20s: Phive download failed..."
fi
