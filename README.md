![PHP Version](https://img.shields.io/badge/php-7.4-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Twitter Follow](https://img.shields.io/twitter/follow/zaioll?label=follow&style=social)

# PHP-ZTS Docker image

PHP is a popular general-purpose scripting language that is especially suited to
web development. Fast, flexible and pragmatic, PHP powers everything from your
blog to the most popular websites in the world.

## PHP Documentation

The PHP manual is available at [php.net/docs](https://php.net/docs).

## Docker image

### Possible PHP versions

At every compilation, the last **patch** version is fetched.

[EBNF](https://bnfplayground.pauliankline.com/?bnf=%3Cphp_version_installed%3E%20%20%20%3A%3A%3D%20%3Cphp_version%3E%20%3Cseparator%3E%20%3Cpatch%3E%0A%3Cphp_version%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%3A%3A%3D%20%3Cmajor%3E%20%3Cseparator%3E%20%3Cminor%3E%0A%3Cmajor%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3A%3A%3D%20%227%22%0A%3Cseparator%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3A%3A%3D%20%22.%22%0A%3Cminor%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3A%3A%3D%20%222%22%20%7C%20%224%22%0A%3Cpatch%3E%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3A%3A%3D%20%20(%20%220%22%20%7C%20%5B1-9%5D%20%5B0-9%5D*)%20%20&name=):

    <php_version_installed>   ::= <php_version> <separator> <patch>
    <php_version>             ::= <major> <separator> <minor>
    <major>                   ::= "7"
    <separator>               ::= "."
    <minor>                   ::= "2" | "4"
    <patch>                   ::=  ( "0" | [1-9] [0-9]*)

## Getting start

### Environment configuration variables

- `PHP_FPM_SOCKET`=( 0 | 1 ) (default `1`)
    - To enable PHP-FPM socket, set `ENABLE_FPM_SOCKET` env var to `1` to create and communicate through unix socket file **/run/php/php7-fpm.sock** or set to `0` for communication through **tcp/9000** port instead.
- `ENABLE_OPCACHE`=( 0 | 1 ) (default `1`)
- `ENABLE_PARALLEL`=( 0 | 1 ) (default `1`)
- `ENABLE_XDEBUG`=( 0 | 1 ) (default `0`)
- [`XDEBUG_CONFIG`](https://xdebug.org/docs/remote)=""
    - If Xdebug is enabled, the PHP-FPM expects xdebug
    configuration through `XDEBUG_CONFIG` env var.
    > If `PHP_FPM_SOCKET` == 0, **xdebug.remote_port** must be different of **9000**.

### Daemon

When running docker image as a daemon, `/run/start.sh` a shell script is executed at startup

```shell
    $ docker run -d -it --name ${my_container_name} -v "${host_path}:/var/www/html" zaioll/php-zts:${php_version}
```

To share the socket file, create shared volume first:

```shell
    $ docker volume create sock
```

Then, run the container passing the created shared volume.

```shell
    $ docker run -d -it -v "sock:/run/php" -v "${host_path}:/var/www/html" --name ${my_container_name} zaioll/php-zts:${php_version}
```

### Interactive

When running docker image as a iteractive form, the `/run/start.sh` shell script is not executed. Then, PHP-FPM is not started. It needs manual run.

## Features

- [Composer 2.X](https://getcomposer.org/) for dependency management in PHP.
- [PhpBench](https://github.com/phpbench/phpbench) tool.
- [Phive](https://phar.io/)

### Installed libs

| Library               | Version                           |
| :---:                 |  :---:                            |
| libacl1               | 2.2.52-3+b1                       |
| libapt-pkg5.0         | 1.4.9                             |
| libaspell15           | 0.60.7~20110707-3+b2              |
| libassuan0            | 2.4.3-2                           |
| libattr1              | 1:2.4.47-2+b2                     |
| libaudit-common       | 1:2.6.7-2                         |
| libaudit1             | 1:2.6.7-2                         |
| libblkid1             | 2.29.2-1+deb9u1                   |
| libbsd0               | 0.8.3-1                           |
| libbz2-1.0            | 1.0.6-8.1                         |
| libc-bin              | 2.24-11+deb9u4                    |
| libc-client2007e      | 8:2007f~dfsg-5                    |
| libc-dev-bin          | 2.24-11+deb9u4                    |
| libc-l10n             | 2.24-11+deb9u4                    |
| libc6                 | 2.24-11+deb9u4                    |
| libc6-dev             | 2.24-11+deb9u4                    |
| libcap-ng0            | 0.7.7-3+b1                        |
| libcap2               | 1:2.25-1                          |
| libcomerr2            | 1.43.4-2+deb9u1                   |
| libcurl3              | 7.52.1-5+deb9u10                  |
| libcurl3-gnutls       | 7.52.1-5+deb9u10                  |
| libdb5.3              | 5.3.28-12+deb9u1                  |
| libdebconfclient0     | 0.227                             |
| libedit2              | 3.1-20160903-3                    |
| libelf1               | 0.168-1                           |
| libenchant1c2a        | 1.6.0-11+b1                       |
| liberror-perl         | 0.17024-1                         |
| libevent-2.0-5        | 2.0.21-stable-3                   |
| libexpat1             | 2.2.0-2+deb9u3                    |
| libfbclient2          | 3.0.1.32609.ds4-14                |
| libfcgi-bin           | 2.4.0-8.4+b1                      |
| libfcgi0ldbl          | 2.4.0-8.4+b1                      |
| libfdisk1             | 2.29.2-1+deb9u1                   |
| libffi6               | 3.2.1-6                           |
| libfreetype6          | 2.6.3-3.2+deb9u1                  |
| libgcc1               | 1:6.3.0-18+deb9u1                 |
| libgcrypt20           | 1.7.6-2+deb9u3                    |
| libgdbm3              | 1.8.3-14                          |
| libglib2.0-0          | 2.50.3-2+deb9u2                   |
| libglib2.0-data       | 2.50.3-2+deb9u2                   |
| libgmp10              | 2:6.1.2+dfsg-1                    |
| libgmpxx4ldbl         | 2:6.1.2+dfsg-1                    |
| libgnutls30           | 3.5.8-5+deb9u4                    |
| libgpg-error0         | 1.26-2                            |
| libgpm2               | 1.20.4-6.2+b1                     |
| libgssapi-krb5-2      | 1.15-1+deb9u1                     |
| libgssrpc4            | 1.15-1+deb9u1                     |
| libhogweed4           | 3.3-1+b2                          |
| libhunspell-1.4-0     | 1.4.1-2+b2                        |
| libicu57              | 57.1-6+deb9u4                     |
| libidn11              | 1.33-1+deb9u1                     |
| libidn2-0             | 0.16-1+deb9u1                     |
| libinotifytools0      | 3.14-2                            |
| libjpeg62-turbo       | 1:1.5.1-2                         |
| libk5crypto3          | 1.15-1+deb9u1                     |
| libkadm5clnt-mit11    | 1.15-1+deb9u1                     |
| libkadm5srv-mit11     | 1.15-1+deb9u1                     |
| libkdb5-8             | 1.15-1+deb9u1                     |
| libkeyutils1          | 1.5.9-9                           |
| libkrb5-3             | 1.15-1+deb9u1                     |
| libkrb5support0       | 1.15-1+deb9u1                     |
| libksba8              | 1.3.5-2                           |
| libldap-2.4-2         | 2.4.44+dfsg-5+deb9u3              |
| libldap-common        | 2.4.44+dfsg-5+deb9u3              |
| libltdl7              | 2.4.6-2                           |
| liblz4-1              | 0.0~r131-2+b1                     |
| liblzma5              | 5.2.2-1.2+b1                      |
| libmcrypt4            | 2.5.8-3.3                         |
| libmemcached11        | 1.0.18-4.1                        |
| libmemcachedutil2     | 1.0.18-4.1                        |
| libmnl0               | 1.0.4-2                           |
| libmongo-client0      | 0.1.8-3.1                         |
| libmount1             | 2.29.2-1+deb9u1                   |
| libmpdec2             | 2.4.2-1                           |
| libncurses5           | 6.0+20161126-1+deb9u2             |
| libncursesw5          | 6.0+20161126-1+deb9u2             |
| libnettle6            | 3.3-1+b2                          |
| libnghttp2-14         | 1.18.1-1+deb9u1                   |
| libnpth0              | 1.3-1                             |
| libonig4              | 6.1.3-2                           |
| libp11-kit0           | 0.23.3-2                          |
| libpam-modules        | 1.1.8-3.6                         |
| libpam-modules-bin    | 1.1.8-3.6                         |
| libpam-runtime        | 1.1.8-3.6                         |
| libpam0g              | 1.1.8-3.6                         |
| libpci3               | 1:3.5.2-1                         |
| libpcre3              | 2:8.39-3                          |
| libperl5.24           | 5.24.1-3+deb9u6                   |
| libpng16-16           | 1.6.28-1+deb9u1                   |
| libpopt0              | 1.16-10+b2                        |
| libpq5                | 9.6.17-0+deb9u1                   |
| libpsl5               | 0.17.0-3                          |
| libpython-stdlib      | 2.7.13-2                          |
| libpython2.7-minimal  | 2.7.13-2+deb9u3                   |
| libpython2.7-stdlib   | 2.7.13-2+deb9u3                   |
| libpython3-stdlib     | 3.5.3-1                           |
| libpython3.5-minimal  | 3.5.3-1+deb9u1                    |
| libpython3.5-stdlib   | 3.5.3-1+deb9u1                    |
| libreadline7          | 7.0-3                             |
| librecode0            | 3.6-23                            |
| librtmp1              | 2.4+20151223.gitfa8646d.1-1+b1    |
| libsasl2-2            | 2.1.27~101-g0780600+dfsg-3+deb    |
| libsasl2-modules      | 2.1.27~101-g0780600+dfsg-3+deb    |
| libsasl2-modules-db   | 2.1.27~101-g0780600+dfsg-3+deb    |
| libselinux1           | 2.6-3+b3                          |
| libsemanage-common    | 2.6-2                             |
| libsemanage1          | 2.6-2                             |
| libsensors4           | 1:3.4.0-4                         |
| libsepol1             | 2.6-2                             |
| libsmartcols1         | 2.29.2-1+deb9u1                   |
| libsnmp-base          | 5.7.3+dfsg-1.7+deb9u1             |
| libsnmp30             | 5.7.3+dfsg-1.7+deb9u1             |
| libsqlite3-0          | 3.16.2-5+deb9u1                   |
| libss2                | 1.43.4-2+deb9u1                   |
| libssh2-1             | 1.7.0-1+deb9u1                    |
| libssl1.0.2           | 1.0.2u-1~deb9u1                   |
| libssl1.1             | 1.1.0l-1~deb9u1                   |
| libstdc++6            | 6.3.0-18+deb9u1                   |
| libsystemd0           | 232-25+deb9u12                    |
| libtasn1-6            | 4.10-1.1+deb9u1                   |
| libtext-iconv-perl    | 1.7-5+b4                          |
| libtinfo5             | 6.0+20161126-1+deb9u2             |
| libtommath1           | 1.0-4                             |
| libudev1              | 232-25+deb9u12                    |
| libunistring0         | 0.9.6+really0.9.3-0.1             |
| libustr-1.0-1         | 1.0.4-6                           |
| libuuid1              | 2.29.2-1+deb9u1                   |
| libwrap0              | 7.6.q-26                          |
| libx11-6              | 2:1.6.4-3+deb9u1                  |
| libx11-data           | 2:1.6.4-3+deb9u1                  |
| libxau6               | 1:1.0.8-1                         |
| libxcb1               | 1.12-1                            |
| libxdmcp6             | 1:1.1.2-3                         |
| libxext6              | 2:1.3.3-1+b2                      |
| libxml2               | 2.9.4+dfsg1-2.2+deb9u2            |
| libxmuu1              | 2:1.1.2-2                         |
| libxslt1.1            | 1.1.29-2.1+deb9u2                 |
| libzip4               | 1.1.2-1.1+b1                      |

### Installed PHP extensions

| Extension                     | Version   |
| :---:                         |  :---:    |
| FFI                           |           |
| Core                          | 7.4.4     |
| date                          | 7.4.4     |
| libxml                        | 7.4.4     |
| openssl                       | 7.4.4     |
| pcre                          | 7.4.4     |
| sqlite3                       | 7.4.4     |
| zlib                          | 7.4.4     |
| bcmath                        | 7.4.4     |
| bz2                           | 7.4.4     |
| calendar                      | 7.4.4     |
| ctype                         | 7.4.4     |
| curl                          | 7.4.4     |
| dom                           | 20031129  |
| enchant                       | 7.4.4     |
| hash                          | 7.4.4     |
| fileinfo                      | 7.4.4     |
| filter                        | 7.4.4     |
| ftp                           | 7.4.4     |
| gd                            | 7.4.4     |
| gettext                       | 7.4.4     |
| SPL                           | 7.4.4     |
| iconv                         | 7.4.4     |
| session                       | 7.4.4     |
| intl                          | 7.4.4     |
| json                          | 7.4.4     |
| mbstring                      | 7.4.4     |
| standard                      | 7.4.4     |
| pcntl                         | 7.4.4     |
| PDO                           | 7.4.4     |
| PDO_Firebird                  | 7.4.4     |
| mysqlnd                       | mysqlnd   |
| pdo_pgsql                     | 7.4.4     |
| pdo_sqlite                    | 7.4.4     |
| pgsql                         | 7.4.4     |
| Phar                          | 7.4.4     |
| posix                         | 7.4.4     |
| pspell                        | 7.4.4     |
| readline                      | 7.4.4     |
| Reflection                    | 7.4.4     |
| imap                          | 7.4.4     |
| SimpleXML                     | 7.4.4     |
| soap                          | 7.4.4     |
| sockets                       | 7.4.4     |
| pdo_mysql                     | 7.4.4     |
| exif                          | 7.4.4     |
| sysvsem                       | 7.4.4     |
| sysvshm                       | 7.4.4     |
| tokenizer                     | 7.4.4     |
| xml                           | 7.4.4     |
| xmlreader                     | 7.4.4     |
| xmlrpc                        | 7.4.4     |
| xmlwriter                     | 7.4.4     |
| xsl                           | 7.4.4     |
| zip                           | 1.15.6    |
| mysqli                        | 7.4.4     |
| decimal                       | 1.3.1     |
| memcached                     | 3.1.5     |
| parallel                      | 1.1.3     |
| redis                         | 5.2.1     |
| Zend                          | OPcache   |
| xdebug                        | 2.9.4     |

### Modules

- [Parallel](https://https://github.com/krakjoe/parallel.git)
- [Swoole](https://www.swoole.co.uk/)
- [Decimal](https://php-decimal.io/)
- [Xdebug](https://github.com/xdebug/xdebug.git)
- [Memcached](https://github.com/php-memcached-dev/php-memcached.git)
- [Mongodb](https://github.com/mongodb/mongo-php-driver.git)
- [Redis](https://github.com/phpredis/phpredis.git)

## Benchmarks

### Environment

The benchmarks were generated by the [Apache ab](https://httpd.apache.org/docs/2.4/programs/ab.html), making requests on `index.php` script over the PHP built-in web server and plotted with the [gnuplot](http://www.gnuplot.info/) program with configurations inspired in [this](http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/) article.

```php
// /index.php
<?php
for ($i = 0; $i < 50; $i++) {
    if ($i % 2 == 0) {
        echo ".";
        continue;
    }
    echo "*";
}
```

```ini
[opcache]
zend_extension=${extension_dir}/opcache.so
opcache.enable=1
opcache.enable_cli=0
opcache.validate_timestamps=0
opcache.max_accelerated_files=65406
opcache.memory_consumption=256
opcache.interned_strings_buffer=12
opcache.fast_shutdown=1
opcache.enable_file_override=1
```

```
# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'

# Output to a jpeg file
set terminal jpeg size 1280,720

# Set the aspect ratio of the graph
set size 1, 1

# The file to write to
set output "<connections>_<concurrency>.jpg"

# The graph title
set title "Benchmark testing with opcache enabled and xdebug disabled: ab -n <connections> -c <concurrency> -g out.data http://localhost/"

# Where to place the legend/key
set key left top

# Draw gridlines oriented on the y axis
set grid y

# Specify that the x-series data is time data
set xdata time

# Specify the *input* format of the time data
set timefmt "%s"

# Specify the *output* format for the x-axis tick labels
set format x "%S"

# Label the x-axis
set xlabel 'seconds'

# Label the y-axis
set ylabel "response time (ms)"

# Plot the data
plot "out.data" every ::2 using 2:5 title 'response time' with points 
exit
```

### Results

- 300 requests, 80 concurrent connections

![Test 01](/benckmarks/300_80_cl.jpg)

![Test 01](/benckmarks/300_80_op.jpg)

- 2000 requests, 800 concurrent connections

![Test 03](/benckmarks/2000_800_cl.jpg)

![Test 04](/benckmarks/2000_800_op.jpg)

- 5000 requests, 800 concurrent connections

![Test 05](/benckmarks/5000_800_cl.jpg)

![Test 06](/benckmarks/5000_800_op.jpg)

- 50000 requests, 1020 concurrent connections

![Test 07](/benckmarks/50000_1020_cl.jpg)

![Test 07](/benckmarks/50000_1020_op.jpg)

## Licence

MIT

---

<a href="https://www.buymeacoffee.com/layro" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-blue.png" alt="Buy Me A Coffee" height="30px" width="120px"></a>
