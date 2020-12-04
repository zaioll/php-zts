#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

echo "install"
figlet "swoole"

pecl install swoole
echo "extension=$(php-config --extension-dir)/swoole.so" >> /etc/php/${php_version}/conf.d/20-swoole.ini \
