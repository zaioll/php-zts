#!/bin/bash

# install latest composer
printf "\ntry download composer...\n"
#curl \
#    --progress-bar \
#    --max-time 60 \
#    --retry-max-time 60 \
#    --retry 5 \
#    --output composer.phar \
#    --location https://getcomposer.org/composer.phar | php &> /dev/null
#
#curl \
#    --progress-bar \
#    --max-time 60 \
#    --retry-max-time 60 \
#    --retry 5 \
#    --output composer.phar.asc \
#    --location https://getcomposer.org/download/latest-stable/composer.phar.asc

#if [ -e composer.phar ] && [ -e composer.phar.asc ];then

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ];then
    >&2 echo 'ERROR: Invalid installer checksum'
    exit 1
fi
php composer-setup.php --quiet

mv composer.phar /usr/local/bin/composer
if [ -e /usr/local/bin/composer ];then
    chmod +x /usr/local/bin/composer
    printf "\n%20s: Composer installed at '/usr/local/bin/composer'."
else
    printf "\n%20s: Composer install failed!"
fi

printf "\nSetting COMPOSER_ALLOW_XDEBUG env var to '0'."
su ${usuario} -c "export COMPOSER_ALLOW_XDEBUG=0"
chown ${usuario}:${usuario} -R ${HOME}
printf "\nInstalling 'phpbench'...\n"
su ${usuario} -c "/usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require phpbench/phpbench @dev -v"

#else
#    printf "\nComposer download failed..."
#fi

printf "\ntry to install phive..."
wget -O phive.phar https://phar.io/releases/phive.phar
wget -O phive.phar.asc https://phar.io/releases/phive.phar.asc
gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79
gpg --verify phive.phar.asc phive.phar

if [ -e phive.phar ]; then
    chmod +x phive.phar
    mv phive.phar /usr/local/bin/phive
    printf "\nPhive installed at '/usr/local/bin/phive'."
else
    printf "\nPhive download failed..."
fi
