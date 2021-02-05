#!/bin/bash
echo "Start PHP"
extension_dir=$(php-config --extension-dir)
config_dir=/etc/php/${php_version}/conf.d
pool_conf=/etc/php/${php_version}/fpm/pool.d/www.conf
major=$(echo ${php_version} | cut -d. -f1)

# control opcache lib load
ENABLE_OPCACHE=${ENABLE_OPCACHE:-0}
if [  ${ENABLE_OPCACHE} -eq 1 ]  && [ -f ${extension_dir}/opcache.so ]; then
    echo "[opcache]" > ${config_dir}/10-opcache.ini
    echo "zend_extension=${extension_dir}/opcache.so" >> ${config_dir}/10-opcache.ini
    echo "opcache.enable=1" >> ${config_dir}/10-opcache.ini
    echo "opcache.enable_cli=0" >> ${config_dir}/10-opcache.ini
    echo "opcache.validate_timestamps=0" >> ${config_dir}/10-opcache.ini
    echo "opcache.max_accelerated_files=65406" >> ${config_dir}/10-opcache.ini
    echo "opcache.memory_consumption=256" >> ${config_dir}/10-opcache.ini
    echo "opcache.interned_strings_buffer=12" >> ${config_dir}/10-opcache.ini
    echo "opcache.fast_shutdown=1" >> ${config_dir}/10-opcache.ini
    echo "opcache.enable_file_override=1" >> ${config_dir}/10-opcache.ini
fi

ENABLE_FPM_SOCKET=${ENABLE_FPM_SOCKET:-1}
if [ ${ENABLE_FPM_SOCKET} -eq 1 ];then
    echo "Enable PHP-FPM socket"
    sed -i -E -e "s|listen = 127\.0\.0\.1\:9000|listen = /run/php/php${major}-fpm.sock|g" ${pool_conf}
else
    echo "Disable PHP-FPM socket"
    sed -i -E -e "s|listen = /run/php/php${major}-fpm.sock|listen = 127\.0\.0\.1\:9000|g" ${pool_conf}
fi

ENABLE_XDEBUG=${ENABLE_XDEBUG:-0}
if [ ${ENABLE_XDEBUG} -eq 1 ] && [ -f ${extension_dir}/xdebug.so ]; then
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
if [ ${ENABLE_PARALLEL} -eq 1 ] && [ -f ${extension_dir}/parallel.so ]; then
    echo "[parallel]" > ${config_dir}/20-parallel.ini
    echo "extension=${extension_dir}/parallel.so" > ${config_dir}/20-parallel.ini
fi

ENABLE_REDIS=${ENABLE_REDIS:-1}
if [ ${ENABLE_REDIS} -eq 1 ] && [ -f ${extension_dir}/redis.so ]; then
    echo "[redis]" > ${config_dir}/20-redis.ini
    echo "extension=${extension_dir}/redis.so" > ${config_dir}/20-redis.ini
fi

ENABLE_MEMCACHED=${ENABLE_MEMCACHED:-1}
if [ ${ENABLE_MEMCACHED} -eq 1 ] && [ -f ${extension_dir}/memcached.so ]; then
    echo "[memcached]" > ${config_dir}/20-memcached.ini
    echo "extension=${extension_dir}/memcached.so" > ${config_dir}/20-memcached.ini
fi

ENABLE_MONGODB=${ENABLE_MONGODB:-1}
if [ ${ENABLE_MONGODB} -eq 1 ] && [ -f ${extension_dir}/mongodb.so ]; then
    echo "[mongodb]" > ${config_dir}/20-mongodb.ini
    echo "extension=${extension_dir}/mongodb.so" > ${config_dir}/20-mongodb.ini
fi


# configure supervisor
sed -i -E -e "s|command=|command=/usr/sbin/php-fpm --fpm-config /etc/php/${php_version}/fpm/php-fpm.conf --pid /run/php/php-fpm.pid -F|g" /etc/supervisor/conf.d/supervisord.conf

# start supervisor and send to background
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf