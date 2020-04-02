#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)

# install php-redis
cd ${install_base}/local/src
version_redis=$(git ls-remote --tags https://github.com/phpredis/phpredis.git | egrep -o '[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$' | tail -n 1)

echo "install"
figlet "php-redis"
echo "from ${version_redis} branch"

curl \
  --progress-bar \
  --max-time 60 \
  --retry-max-time 60 \
  --retry 5 \
  --location https://github.com/phpredis/phpredis/archive/${version_redis}.tar.gz | tar xzf -

mv phpredis* phpredis
cd phpredis

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-redis.log) 2> >(tee /info/compile-php-redis.err >&2)
cp modules/redis.so ${extension_dir}/redis.so
