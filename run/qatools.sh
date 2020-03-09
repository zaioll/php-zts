#!/bin/bash

# install latest composer
echo "installing composer..."
curl -# -L https://getcomposer.org/installer | php &> /dev/null
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
