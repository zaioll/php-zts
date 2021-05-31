#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

echo "install"
figlet "php-sodium"

pecl install libsodium
echo "extension=$(php-config --extension-dir)/sodium.so" >> /etc/php/${php_version}/conf.d/20-sodium.ini \
