#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

# install php-xdebug
cd $INSTALL_BASE/src
version_xdebug=$(git ls-remote --tags https://github.com/xdebug/xdebug.git | egrep -o '[0-9]*\.[0-9]*\.[0-9]*(RC[0-9]*)?$' | tail -n 1 | cut -d_ -f2-4)

echo "install"
figlet "php-xdebug"
echo "version $version_xdebug"

curl --progress-bar --max-time 60 --retry-max-time 60 --retry 5 --location https://github.com/xdebug/xdebug/archive/${version_xdebug}.tar.gz | tar xzf -
mv xdebug* xdebug
cd xdebug

phpize
./configure --enable-xdebug
make -j$(nproc) > >(tee /info/compile-php-xdebug.log) 2> >(tee /info/compile-php-xdebug.err >&2)
cp modules/xdebug.so $extension_dir/xdebug.so
