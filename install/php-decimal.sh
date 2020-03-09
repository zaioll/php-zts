#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

echo "install"
figlet "php-decimal"

pecl install decimal
echo "extension=/usr/lib/php/20170718-zts-debug/decimal.so" >> /etc/php/${VERSION}/conf.d/20-decimal.ini \
