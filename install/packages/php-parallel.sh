#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi


# install php-parallel
if [ ! -d ${install_base}/local/src/parallel ]; then
  exit 1
fi

cd ${install_base}/local/src/parallel
version_parallel=$(git ls-remote --tags https://github.com/krakjoe/parallel.git | egrep -o 'v?[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$' | tail -n 1)

echo "install"
figlet "php-parallel"
echo "version $(echo ${version_parallel} | cut -b 2-)"

phpize
./configure --enable-parallel  --enable-parallel-coverage
make -j$(nproc) > >(tee /info/compile-php-parallel.log) 2> >(tee /info/compile-php-parallel.err >&2)
make install

extension_dir=$(php-config --extension-dir)
cp modules/parallel.so ${extension_dir}/parallel.so