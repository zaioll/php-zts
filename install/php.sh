
DEBIAN_FRONTEND=noninteractive apt-get remove php-cli -y
DEBIAN_FRONTEND=noninteractive apt-get install tree git -y

major=$(echo $VERSION | cut -d. -f1)
minor=$(echo $VERSION | cut -d. -f2)
full_version=$(git ls-remote --tags https://github.com/php/php-src | grep -Eo "php-${major}\.${minor}\.[0-9]{2}$" | tail -n 1 | cut -d- -f2)
patch=$(echo $full_version | cut -d. -f3)

install_path=$INSTALL_BASE/local/src

prefix=$INSTALL_BASE
sysconfdir="/etc"

cd $install_path

curl --progress-bar --max-time 60 --retry-max-time 60 --retry 5 --location https://github.com/php/php-src/archive/php-${full_version}.tar.gz | tar xzf -

echo "install"
figlet "php"
echo "version $full_version"

mv php* php
cd php

./buildconf --force
./configure \
   --prefix=${prefix} \
   --sysconfdir=${sysconfdir} \
   --includedir=${prefix}/share \
   --with-layout=GNU \
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
   --with-firebird \
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
   --with-config-file-path=${sysconfdir}/php/${VERSION} \
   --with-config-file-scan-dir=${sysconfdir}/php/${VERSION}/conf.d \
   --enable-cli \
   --enable-maintainer-zts \
   --with-tsrm-pthreads \
   --enable-debug \
   --enable-fpm \
   --with-fpm-user=www-data \
   --with-fpm-group=www-data 

make -j$(nproc) > >(tee /info/compile-${PWD##*/}.log) 2> >(tee /info/compile-${PWD##*/}.err >&2) 
make install 

chmod o+x ${prefix}/bin/phpize 
chmod o+x ${prefix}/bin/php-config 

mkdir -p ${sysconfdir}/php/${VERSION}/conf.d 
mkdir -p ${sysconfdir}/php/${VERSION}/fpm 
mkdir -p ${sysconfdir}/php/${VERSION}/fpm/pool.d 
rm -R /etc/php-fpm.d /etc/php-fpm.conf.default 

cp ${install_path}/php/php.ini-production ${sysconfdir}/php/${VERSION}/php-cli.ini 
cp ${install_path}/php/php.ini-production ${sysconfdir}/php/${VERSION}/fpm/php.ini 
cp ${install_path}/php/sapi/fpm/www.conf ${sysconfdir}/php/${VERSION}/fpm/pool.d/www.conf 
cp ${install_path}/php/sapi/fpm/php-fpm.conf ${sysconfdir}/php/${VERSION}/fpm/php-fpm.conf

if [ ${FPM_SOCKET} -eq 1 ];then
   sed -i "s#listen = 127\.0\.0\.1\:9000#listen = /run/php/php${major}-fpm.sock#g" ${sysconfdir}/php/${VERSION}/fpm/pool.d/www.conf 
fi
sed -i 's#;listen.owner = www-data#listen.owner = www-data#g' ${sysconfdir}/php/${VERSION}/fpm/pool.d/www.conf 
sed -i 's#;listen.group = www-data#listen.group = www-data#g' ${sysconfdir}/php/${VERSION}/fpm/pool.d/www.conf 
sed -i 's#;listen.mode = www-data#listen.mode = www-mode#g' ${sysconfdir}/php/${VERSION}/fpm/pool.d/www.conf 
sed -i "s#include=/etc/php-fpm.d/\*\.conf#include=${sysconfdir}/php/${VERSION}/fpm/pool.d/*.conf#g" ${sysconfdir}/php/${VERSION}/fpm/php-fpm.conf

tree ${sysconfdir}/php
tree $(php-config --includedir)

#cat /run/php.ini $(php-config --prefix)/etc/all-ext.ini>${sysconfdir}/php/php-all-ext.ini