#!/bin/bash

#if [ ! -f /.initialized ]; then
  #/run/certs.sh
  #/run/configs.sh

  #touch /.initialized
#fi

/configure/_run-preload.sh

figlet "php $(php-config --version)"
php -v
printf "\n"
if [ -d /etc/php/${php_version}/conf.d ] && [ -f /etc/php/${php_version}/php-cli.ini ];then
  printf "%20s: %s\n" "php ini conf path" "/etc/php/${php_version}/conf.d/php-cli.ini"
else
  printf "%20s: diretório de conf incorreto\n"
fi
if [ -d /etc/php/${php_version}/fpm ] && [ -f /etc/php/${php_version}/fpm/php.ini ];then
  printf "%20s: %s\n" "php-fpm conf path" "/etc/php/${php_version}/fpm/php.ini"
else
  printf "%20s: diretório de conf fpm incorreto\n"
fi
printf "%20s  %s\n" "" "set volumes appropriately"
printf "\n"

# Create php dir to create php-fpm socket file and php-fpm pid
mkdir /run/php

chmod +x /configure/start.sh
mv /configure/start.sh /run/start.sh

mv /configure/supervisord.conf /etc/supervisor/conf.d

# limpa
rm -fr /configure
rm -fr /install
