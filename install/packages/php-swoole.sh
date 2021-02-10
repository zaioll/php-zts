#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi
if [ -z $(type -P php) ];then
  exit 1;
fi

swoole_version="$(git ls-remote --tags https://github.com/swoole/swoole-src.git | egrep -o 'v?[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,}$' | tail -n 1)"

cd ${install_base}/local/src

echo "Download swoole..."

curl \
  --progress-bar \
  --max-time 60 \
  --retry-max-time 60 \
  --retry 5 \
  --location https://github.com/swoole/swoole-src/archive/${swoole_version}.tar.gz | tar xzf -

mv swoole* swoole
if [ ! -d swoole ];then
  echo "Falha ao baixar Swoole!"
  exit 1;
fi

cd swoole 

#compile e install

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

phpize && \
./configure \
--enable-openssl \
--with-openssl-dir="/usr/lib/x86_64-linux-gnu" \
--enable-sockets \
--enable-http2 \
--enable-mysqlnd 

make -j$(nproc) > >(tee /info/compile-${PWD##*/}.log) 2> >(tee /info/compile-${PWD##*/}.err >&2) 
make install

figlet $(php -m | grep swoole)