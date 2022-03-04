#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

echo "install"
figlet "php-uuid"

pecl install uuid
echo "extension=$(php-config --extension-dir)/uuid.so" >> /etc/php/${php_version}/conf.d/20-uuid.ini
