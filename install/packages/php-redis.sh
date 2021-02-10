#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

if [ ! -d ${install_base}/local/src/redis ]; then
  echo "Redis source files doesn't located!"
  exit 1
fi

# install php-redis
cd ${install_base}/local/src/redis
version_redis=$(git ls-remote --tags https://github.com/phpredis/phpredis.git | egrep -o '[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$' | tail -n 1)

echo "install"
figlet "php-redis"
echo "from ${version_redis} branch"

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-redis.log) 2> >(tee /info/compile-php-redis.err >&2)

extension_dir=$(php-config --extension-dir)
cp modules/redis.so ${extension_dir}/redis.so
