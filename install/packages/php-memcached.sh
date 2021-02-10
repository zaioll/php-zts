#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

if [ ! -d ${install_base}/local/src/memcached ]; then
  echo "Memcached não encontrado!"
  exit 1
fi

cd ${install_base}/local/src/memcached
branch_memcached="$(git ls-remote --tags https://github.com/php-memcached-dev/php-memcached.git | egrep -o 'v?[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,}$' | tail -n 1)"

echo "install"
figlet "php-memcached"
echo "from ${branch_memcached} branch"

# configure and compile
phpize
./configure --enable-memcached --with-libmemcached-dir --disable-memcached-sasl
make -j$(nproc) > >(tee /info/compile-php-memcached.log) 2> >(tee /info/compile-php-memcached.err >&2)

extension_dir=$(php-config --extension-dir)
cp modules/memcached.so ${extension_dir}/memcached.so
