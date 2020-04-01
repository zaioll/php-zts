#!/bin/bash

extension_dir=$(php-config --extension-dir)
config_dir=$(php-config --ini-dir)
pool_conf=$(php-config --ini-path)/fpm/pool.d/www.conf
major=$(echo ${php_version} | cut -d. -f1)

if [ ${ENABLE_FPM_SOCKET} -eq 1 ];then
    sed -i "s|listen = 127\.0\.0\.1\:9000|listen = /run/php/php${major}-fpm.sock|g" ${pool_conf}
else
    sed -i "s|listen = /run/php/php${major}-fpm.sock|listen = 127\.0\.0\.1\:9000|g" ${pool_conf}
fi

if [ ${ENABLE_XDEBUG} -eq 1 ]; then
    echo "[Xdebug]" > "${config_dir}/20-xdebug.ini"
    echo "zend_extension=${extension_dir}/xdebug.so" >> ${config_dir}/20-xdebug.ini
    echo "env[XDEBUG_CONFIG]=\$XDEBUG_CONFIG" >> ${pool_conf}
else
    if [ -f ${config_dir}/20-xdebug.ini ]; then
        rm -f ${config_dir}/20-xdebug.ini 
    fi
    sed -i -E -e "s|env[XDEBUG_CONFIG]=\$XDEBUG_CONFIG||g" ${pool_conf}
fi

# control parallel lib load
ENABLE_PARALLEL=${ENABLE_PARALLEL:-1}
if [ ${ENABLE_PARALLEL} -eq 1 ]; then
    echo "[parallel]" > ${config_dir}/20-parallel.ini
    echo "extension=${extension_dir}/parallel.so" > ${config_dir}/20-parallel.ini
fi

# configure supervisor
sed -i -E -e "s|command=|command=/usr/sbin/php-fpm --fpm-config /etc/php/${php_version}/fpm/php-fpm.conf --pid /run/php/php-fpm.pid -F|g" /etc/supervisor/conf.d/supervisord.conf

# start supervisor and send to background
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf