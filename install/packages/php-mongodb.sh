#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

if [ ! -d ${install_base}/local/src/mongodb ]; then
  echo "Mongodb não encontrado!"
  exit 1
fi

# install php-mongodb
cd ${install_base}/local/src/mongodb
version_mongodb=$(git ls-remote --tags https://github.com/mongodb/mongo-php-driver.git | egrep -o 'v?[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$' | tail -n 1)

echo "install"
figlet "php-mongodb"
echo "version ${version_mongodb}"

# configure and compile
phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-mongodb.log) 2> >(tee /info/compile-php-mongodb.err >&2)

extension_dir=$(php-config --extension-dir)
cp modules/mongodb.so ${extension_dir}/mongodb.so
