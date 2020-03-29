#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

echo "install"
figlet "php-decimal"

pecl install decimal
echo "extension=/usr/lib/php/20190902-zts-debug/decimal.so" >> /etc/php/${php_version}/conf.d/20-decimal.ini \
