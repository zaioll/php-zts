#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get install -y $(cat /install/requirements/*packages | tr "\n" " ")

ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so
ln -s /usr/lib/x86_64-linux-gnu/libldap.a /usr/lib/libldap.a

echo "Ajustando timezone, data e hora"
export TZ=America/Cuiaba
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
