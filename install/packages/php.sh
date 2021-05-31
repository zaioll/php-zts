#!/bin/bash

install_path=${install_base}/local/src
if [ ! -d ${install_path}/php ]; then
   echo "PHP source files doesn't located!"
   exit 1
fi

major=$(echo ${php_version} | cut -d. -f1)
minor=$(echo ${php_version} | cut -d. -f2)
full_version=$(git ls-remote --tags https://github.com/php/php-src | grep -Eo "php-${major}\.${minor}\.[0-9]{1,2}$" | tail -n 1 | cut -d- -f2)
patch=$(echo ${full_version} | cut -d. -f3)

full_version="${php_version}.${patch}"

prefix=${install_base}
sysconfdir="/etc"

echo "Try to compile and install PHP ${full_version}..."

export PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
export PHP_CPPFLAGS="${PHP_CFLAGS}"
export PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

cd ${install_path}/php

./buildconf --force
./configure \
   --prefix=${prefix} \
   --sysconfdir=${sysconfdir} \
   --includedir=${prefix}/share \
   --with-layout=GNU \
   --with-gmp \
   --with-bz2 \
   --with-zlib-dir \
   --with-ffi \
   --with-zlib \
   --with-openssl \
   --with-readline \
   --with-curl \
   --with-pspell \
   --with-enchant \
   --with-gettext \
   --with-pdo-pgsql=pgsql \
   --with-mysqli=mysqlnd \
   --with-pdo-mysql=mysqlnd \
   --with-pdo-firebird \
   --with-xsl \
   --with-config-file-path=${sysconfdir}/php/${php_version} \
   --with-config-file-scan-dir=${sysconfdir}/php/${php_version}/conf.d \
   --with-tsrm-pthreads \
   --with-pgsql \
   --with-mhash \
   --with-zip \
   --with-jpeg \
   --with-imap \
   --with-imap-ssl \
   --with-kerberos \
   --with-xmlrpc \
   --with-pear \
   --with-mysql-sock=/var/run/mysqld/mysqld.sock \
   --with-fpm-user=www-data \
   --with-fpm-group=www-data \
   --disable-rpath \
   --disable-cgi \
   --enable-pdo \
   --enable-tokenizer \
   --enable-soap \
   --enable-intl \
   --enable-option-checking=fatal \
   --enable-ftp \
   --enable-mysqlnd \
   --enable-sockets \
   --enable-pcntl \
   --enable-exif \
   --enable-bcmath \
   --enable-mbstring \
   --enable-calendar \
   --enable-simplexml \
   --enable-json \
   --enable-session \
   --enable-xml \
   --enable-opcache \
   --enable-cli \
   --enable-maintainer-zts \
   --enable-debug \
   --enable-fpm \
   --enable-gd \
   --enable-sysvsem \
   --enable-sysvshm \
   --enable-inline-optimization \
   --enable-mbregex


# compile and install
make -j$(nproc) > >(tee /info/compile-${PWD##*/}.log) 2> >(tee /info/compile-${PWD##*/}.err >&2) 
make install 

chmod o+x ${prefix}/bin/phpize 
chmod o+x ${prefix}/bin/php-config 

mkdir -p ${sysconfdir}/php/${php_version}/conf.d 
mkdir -p ${sysconfdir}/php/${php_version}/fpm 
mkdir -p ${sysconfdir}/php/${php_version}/fpm/pool.d 
rm -R /etc/php-fpm.d /etc/php-fpm.conf.default 

cp ${install_path}/php/php.ini-production ${sysconfdir}/php/${php_version}/php-cli.ini 
cp ${install_path}/php/php.ini-production ${sysconfdir}/php/${php_version}/fpm/php.ini 
cp ${install_path}/php/sapi/fpm/www.conf ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
cp ${install_path}/php/sapi/fpm/php-fpm.conf ${sysconfdir}/php/${php_version}/fpm/php-fpm.conf

sed -i 's#;listen.owner = www-data#listen.owner = www-data#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i 's#;listen.group = www-data#listen.group = www-data#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i 's#;listen.mode = www-data#listen.mode = www-mode#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i "s#include=/etc/php-fpm.d/\*\.conf#include=${sysconfdir}/php/${php_version}/fpm/pool.d/*.conf#g" ${sysconfdir}/php/${php_version}/fpm/php-fpm.conf

# test php install
#make -j$(nproc) test

figlet "php $(php-config --version)"