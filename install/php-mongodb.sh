#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

# install php-mongodb
cd $INSTALL_BASE/src
version_mongodb=$(git ls-remote --tags https://github.com/mongodb/mongo-php-driver.git | egrep -o '[0-9]*\.[0-9]*\.[0-9]*$' | tail -n 1)

echo "install"
figlet "php-mongodb"
echo "version $version_mongodb"

curl --progress-bar --max-time 60 --retry-max-time 60 --retry 5 --location https://github.com/mongodb/mongo-php-driver/releases/download/${version_mongodb}/mongodb-${version_mongodb}.tgz  | tar xzf -
mv mongodb* mongodb
cd mongodb

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-mongodb.log) 2> >(tee /info/compile-php-mongodb.err >&2)
cp modules/mongodb.so $extension_dir/mongodb.so
