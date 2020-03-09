#!/bin/bash

if [ -z $INSTALL_BASE ]; then
  exit 1
fi

number_cores=$(nproc)

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --prefix)/etc/conf.d

# install zephir
cd $INSTALL_BASE
branch_zephir="master"

echo "install"
figlet "zephir"
echo "from $branch_zephir branch"

git clone https://github.com/phalcon/zephir.git --branch $branch_zephir --single-branch
cd zephir
./install -c

# install php-phalcon
cd $INSTALL_BASE/src
# version_phalcon=$(git ls-remote --tags https://github.com/phalcon/cphalcon.git | egrep -o 'phalcon-v[0-9]*\.[0-9]*\.[0-9]*$' | tail -n 1 | cut -dv -f2)
# curl --progress-bar --max-time 60 --retry-max-time 60 --retry 5 --location https://github.com/phalcon/cphalcon/archive/phalcon-v${version_phalcon}.tar.gz | tar xzf -
branch_phalcon="master"

echo "install"
figlet "php-phalcon"
# echo "version $version_phalcon"
echo "from $branch_phalcon branch"

git clone https://github.com/phalcon/cphalcon.git --branch $branch_phalcon --single-branch
cd cphalcon
echo "memory_limit=256M">$config_dir/__cphalcon-install.ini
sed -i -e "s/make &&/make -j$number_cores &&/g" build/inst*
zephir build --backend=ZendEngine3
rm -rf $config_dir/__cphalcon-install.ini
