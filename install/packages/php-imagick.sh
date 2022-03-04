#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

echo "install"
figlet "php-imagick"

pecl install imagick
echo "extension=$(php-config --extension-dir)/imagick.so" >> /etc/php/${php_version}/conf.d/20-imagick.ini
