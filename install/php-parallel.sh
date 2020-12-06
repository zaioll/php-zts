#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --ini-dir)

# install php-parallel
cd ${install_base}/local/src
version_parallel=$(git ls-remote --tags https://github.com/krakjoe/parallel.git | egrep -o 'v?[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$' | tail -n 1)

echo "install"
figlet "php-parallel"
echo "version $(echo ${version_parallel} | cut -b 2-)"

# Download
curl \
  --progress-bar \
  --max-time 60 \
  --retry-max-time 60 \
  --retry 5 \
  --location https://github.com/krakjoe/parallel/archive/${version_parallel}.tar.gz | tar xzf -

mv parallel* parallel
cd parallel

phpize
./configure --enable-parallel  --enable-parallel-coverage
make -j$(nproc) > >(tee /info/compile-php-parallel.log) 2> >(tee /info/compile-php-parallel.err >&2)
make install

cp modules/parallel.so ${extension_dir}/parallel.so
