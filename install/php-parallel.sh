#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --ini-dir)

# install php-parallel
cd ${install_base}/local/src
version_pthreads=$(git ls-remote --tags https://github.com/krakjoe/parallel.git | grep -o 'v[0-9]*.[0-9]*.[0-9]*$' | tail -n 1 | cut -b 2-)

echo "install"
figlet "php-parallel"
echo "version ${version_pthreads}"

# Download
curl \
  --progress-bar \
  --max-time 60 \
  --retry-max-time 60 \
  --retry 5 \
  --location https://github.com/krakjoe/parallel/archive/v${version_pthreads}.tar.gz | tar xzf -

mv parallel* parallel
cd parallel

phpize
./configure --enable-parallel  --enable-parallel-coverage
make -j$(nproc) > >(tee /info/compile-php-parallel.log) 2> >(tee /info/compile-php-parallel.err >&2)
cp modules/parallel.so ${extension_dir}/parallel.so
