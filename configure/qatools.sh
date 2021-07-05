#!/bin/bash

# install latest composer
echo -e "try download composer...\n"
fail="no"
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
        echo "Composer installed at '/usr/local/bin/composer'."
    else
        echo "Composer install failed!"
        fail="yes" 
    fi

    chown ${usuario}:${usuario} -R ${HOME}
    if [ "${fail}" = "no" ];then
        echo -e "Installing 'phpbench'...\n"
        su ${usuario} -c "/usr/bin/php -d memory_limit=-1 /usr/local/bin/composer global require phpbench/phpbench @dev -v"
        su ${usuario} -c "/usr/local/bin/composer clearcache"
    fi
else
    echo "Composer download failed..."
    fail="yes"
fi

echo "try to install phive..."
wget -O phive.phar https://phar.io/releases/phive.phar
wget -O phive.phar.asc https://phar.io/releases/phive.phar.asc
gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79
gpg --verify phive.phar.asc phive.phar

if [ -e phive.phar ]; then
    chmod +x phive.phar
    mv phive.phar /usr/local/bin/phive
    echo "Phive installed at '/usr/local/bin/phive'."
else
    echo "Phive download failed..."
    fail="yes"
fi

exit 0
