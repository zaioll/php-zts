if [ -z $(type -P php) ];then
  exit 1;
fi


apt-get purge -y $(cat /install/_dev-packages | tr "\n" " ")
apt-get clean -y
apt-get autoclean -y
apt-get autoremove -y

rm -rf /usr/share/locale/*
rm -rf /var/cache/debconf/*-old
rm -rf /var/lib/apt/lists/*
rm -rf /usr/share/doc/*
rm -rf /var/log/*

dpkg-query --show --showformat='${Package;-30} ${Version;-30} ${Status}\n' | grep installed | grep ^lib | awk '{printf "%-30s %s\n",$1,$2}'>/info/installed-libs

ext_dir=$(php-config --extension-dir)
all_ext_ini=/etc/php/all-ext.ini
:>${all_ext_ini}
for f in ${ext_dir}/*.so; do
  z=$(basename $f)
  if [[ $z == "opcache.so" ]] || [[ $z == "xdebug.so" ]]; then
    echo "zend_extension=${f}">>${all_ext_ini}
  else
    echo "extension=${f}">>${all_ext_ini}
  fi
done

php -c ${all_ext_ini} -r 'foreach (get_loaded_extensions() as $e) { echo "$e\t" . phpversion($e) . "\n"; }' | awk '{printf "%-30s %s\n",$1,$2}'>/info/installed-php-extensions

rm -rf ${install_base}/local/src/*
