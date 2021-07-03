#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi
if [ -z $(type -P php) ];then
  exit 1;
fi

DEBIAN_FRONTEND=noninteractive apt-get remove --purge libssl-dev -y && apt-get install -y libssh-dev librabbitmq-dev libssl1.0-dev
echo -e "libssh-dev librabbitmq-dev libssl1.0-dev\n" >> /install/requirements/_dev-packages

pecl install amqp
echo "extension=$(php-config --extension-dir)/amqp.so" >> /etc/php/${php_version}/conf.d/20-amqp.ini
chmod +x $(php-config --extension-dir)/amqp.so

figlet "php-amqp"