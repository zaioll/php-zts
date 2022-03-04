#!/bin/bash

install_with_pecl=${install_with_pecl:-"no"}

if [ -z ${install_base} ]; then
  exit 1
fi
if [ -z $(type -P php) ];then
  exit 1;
fi

if [ "{$install_with_pecl}" = "yes" ];then
  pecl install amqp
  echo "extension=$(php-config --extension-dir)/amqp.so" >> /etc/php/${php_version}/conf.d/20-amqp.ini
  figlet "php-ampq"
  exit 0
fi

if [ ! -d ${install_base}/local/src/amqp ]; then
  echo "AMQP não encontrado!"
  exit 1
fi

cd ${install_base}/local/src/amqp

DEBIAN_FRONTEND=noninteractive apt-get install -y libssh-dev librabbitmq-dev
echo -e "libssh-dev librabbitmq-dev\n" >> /install/requirements/_dev-packages

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-amqp.log) 2> >(tee /info/compile-php-amqp.err >&2)

extension_dir=$(php-config --extension-dir)
cp modules/amqp.so ${extension_dir}/amqp.so

echo "extension=$(php-config --extension-dir)/amqp.so" >> /etc/php/${php_version}/conf.d/20-amqp.ini
chmod +x $(php-config --extension-dir)/amqp.so

figlet "php-amqp"