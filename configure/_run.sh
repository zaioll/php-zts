#!/bin/bash

/configure/_run-preload.sh

figlet "php $(php-config --version)"
php -v
printf "\n"
if [ -d /etc/php/${php_version}/conf.d ] && [ -f /etc/php/${php_version}/php-cli.ini ];then
  printf "%s\n" "php ini conf path" "/etc/php/${php_version}/conf.d/php-cli.ini"
else
  printf "diretório de conf incorreto\n"
fi
if [ -d /etc/php/${php_version}/fpm ] && [ -f /etc/php/${php_version}/fpm/php.ini ];then
  printf "%s\n" "php-fpm conf path" "/etc/php/${php_version}/fpm/php.ini"
else
  printf "diretório de conf fpm incorreto\n"
fi
printf "\n" "" "set volumes appropriately"
printf "\n"

# Create php dir to create php-fpm socket file and php-fpm pid
mkdir /run/php

mv /configure/supervisord.conf /etc/supervisor/conf.d

# limpa
#rm -fr /configure
#rm -fr /install
