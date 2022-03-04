#!/bin/bash

if [ -z ${install_base} ]; then
  exit 1
fi
if [ -z $(type -P php) ];then
  exit 1;
fi

if [ ! -d ${install_base}/local/src/swoole ]; then
  echo "Swoole source files doesn't located!"
  exit 1
fi

cd ${install_base}/local/src/swoole
#compile e install

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

phpize && \
./configure \
--enable-openssl \
--with-openssl-dir="/usr/lib/x86_64-linux-gnu" \
--enable-sockets \
--enable-swoole-curl \
--enable-http2 \
--with-postgres \
--enable-mysqlnd 

make -j$(nproc) > >(tee /info/compile-${PWD##*/}.log) 2> >(tee /info/compile-${PWD##*/}.err >&2) 
make install

figlet $(php -m | grep swoole)
