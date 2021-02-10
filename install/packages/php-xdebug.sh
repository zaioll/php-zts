#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi
if [ -z $(type -P php) ];then
  exit 1;
fi

if [ ! -d ${install_base}/local/src/xdebug ]; then
  echo "Xdebug source files doesn't located!"
  exit 1
fi


# install php-xdebug
cd ${install_base}/local/src/xdebug

version_xdebug=$(git ls-remote --tags https://github.com/xdebug/xdebug.git | egrep -o '[0-9]+\.[0-9]+\.[0-9]*$' | tail -n 1 | cut -d_ -f2-4)

echo "install"
figlet "php-xdebug"
echo "version ${version_xdebug}"

phpize
./configure --enable-xdebug
make -j$(nproc) > >(tee /info/compile-php-xdebug.log) 2> >(tee /info/compile-php-xdebug.err >&2)

extension_dir=$(php-config --extension-dir)
cp modules/xdebug.so ${extension_dir}/xdebug.so
