
major=$(echo ${php_version} | cut -d. -f1)
minor=$(echo ${php_version} | cut -d. -f2)
patch=$(git ls-remote --tags https://github.com/php/php-src | grep -Eo "php-${major}\.${minor}\.[0-9]{1,}$" | cut -d. -f3 | sort -g | tail -n 1)

full_version="${php_version}.${patch}"
install_path=${install_base}/local/src

prefix=${install_base}
sysconfdir="/etc"

cd ${install_path}

echo "Download PHP ${full_version}..."
# Download PHP
curl \
   --progress-bar \
   --max-time 60 \
   --retry-max-time 60 \
   --retry 5 \
   --location https://github.com/php/php-src/archive/php-${full_version}.tar.gz | tar xzf -

echo "Try to compile and install PHP ${full_version}..."
mv php* php
cd php

./buildconf --force
./configure \
   --prefix=${prefix} \
   --sysconfdir=${sysconfdir} \
   --includedir=${prefix}/share \
   --with-layout=GNU \
   --with-fpm-user=www-data \
   --with-fpm-group=www-data \
   --with-config-file-path=${sysconfdir}/php/${php_version} \
   --with-config-file-scan-dir=${sysconfdir}/php/${php_version}/conf.d \
   --with-bz2 \
   --with-zlib \
   --enable-zip \
   --disable-cgi \
   --enable-soap \
   --enable-intl \
   --with-openssl \
   --with-readline \
   --with-curl \
   --enable-ftp \
   --with-pdo-pgsql=pgsql \
   --enable-mysqlnd \
   --with-mysqli=mysqlnd \
   --with-pdo-mysql=mysqlnd \
   --with-pdo-firebird \
   --enable-sockets \
   --enable-pcntl \
   --with-pspell \
   --with-enchant \
   --with-gettext \
   --with-gd \
   --enable-exif \
   --with-jpeg-dir \
   --with-png-dir \
   --with-freetype-dir \
   --with-xsl \
   --enable-bcmath \
   --enable-mbstring \
   --enable-calendar \
   --enable-simplexml \
   --enable-json \
   --enable-hash \
   --enable-session \
   --enable-xml \
   --enable-wddx \
   --enable-opcache \
   --with-pcre-regex \
   --enable-cli \
   --enable-maintainer-zts \
   --with-tsrm-pthreads \
   --enable-debug \
   --enable-fpm \
   --with-pear \
   --disable-rpath \
   --enable-sysvsem \
   --enable-sysvshm \
   --enable-inline-optimization \
   --enable-mbregex \
   --with-mhash \
   --with-libzip \
   --with-imap \
   --with-imap-ssl \
   --with-kerberos \
   --with-xmlrpc
 
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

sed -i -E 's#;listen.owner = (nobody|www-data)#listen.owner = www-data#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i -E 's#;listen.group = (nobody|www-data)#listen.group = www-data#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i -E 's#;listen.mode = www-data#listen.mode = www-mode#g' ${sysconfdir}/php/${php_version}/fpm/pool.d/www.conf 
sed -i -E "s#include=/etc/php-fpm.d/\*\.conf#include=${sysconfdir}/php/${php_version}/fpm/pool.d/*.conf#g" ${sysconfdir}/php/${php_version}/fpm/php-fpm.conf

# test php install
#make -j$(nproc) test

figlet "php $(php-config --version)"