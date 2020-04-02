#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)

cd ${install_base}/local/src
# install php-memcached
branch_memcached="$(git ls-remote --tags https://github.com/php-memcached-dev/php-memcached.git | egrep -o 'v?[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,}$' | tail -n 1)"

echo "install"
figlet "php-memcached"
echo "from ${branch_memcached} branch"

curl \
  --progress-bar \
  --max-time 60 \
  --retry-max-time 60 \
  --retry 5 \
  --location "https://github.com/php-memcached-dev/php-memcached/archive/${branch_memcached}.tar.gz" | tar xzf -

mv php-memcached* php-memcached
cd php-memcached

# configure and compile
phpize
./configure --enable-memcached --with-libmemcached-dir --disable-memcached-sasl
make -j$(nproc) > >(tee /info/compile-php-memcached.log) 2> >(tee /info/compile-php-memcached.err >&2)

cp modules/memcached.so ${extension_dir}/memcached.so
