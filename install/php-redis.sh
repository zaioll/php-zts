#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

# install php-redis
cd $INSTALL_BASE/src
branch_redis="master"

echo "install"
figlet "php-redis"
echo "from $branch_redis branch"

git clone https://github.com/phpredis/phpredis.git --branch $branch_redis --single-branch
cd phpredis

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-redis.log) 2> >(tee /info/compile-php-redis.err >&2)
cp modules/redis.so $extension_dir/redis.so
