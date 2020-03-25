#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

cd $INSTALL_BASE/local/src
# install php-memcached
branch_memcached="v3.1.5"

echo "install"
figlet "php-memcached"
echo "from $branch_memcached branch"

git clone https://github.com/php-memcached-dev/php-memcached.git --branch $branch_memcached --single-branch
cd php-memcached

phpize
./configure --enable-memcached --with-libmemcached-dir --disable-memcached-sasl
make -j$(nproc) > >(tee /info/compile-php-memcached.log) 2> >(tee /info/compile-php-memcached.err >&2)

cp modules/memcached.so $extension_dir/memcached.so
