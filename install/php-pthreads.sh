#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

# install php-pthreads
cd $INSTALL_BASE/src
version_pthreads=$(git ls-remote --tags https://github.com/krakjoe/pthreads.git | grep -o 'v[0-9]*.[0-9]*.[0-9]*$' | tail -n 1 | cut -b 2-)

echo "install"
figlet "php-pthreads"
echo "version $version_pthreads"

curl --progress-bar --max-time 60 --retry-max-time 60 --retry 5 --location https://github.com/krakjoe/pthreads/archive/v${version_pthreads}.tar.gz | tar xzf -
mv pthreads* pthreads
cd pthreads

phpize
./configure
make -j$(nproc) > >(tee /info/compile-php-pthreads.log) 2> >(tee /info/compile-php-pthreads.err >&2)
cp modules/pthreads.so $extension_dir/pthreads.so
