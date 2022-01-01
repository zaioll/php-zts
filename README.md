![PHP Version](https://img.shields.io/badge/php-7.4-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Twitter Follow](https://img.shields.io/twitter/follow/zaioll?label=follow&style=social)

# PHP-ZTS Docker image

PHP is a popular general-purpose scripting language that is especially suited to
web development. Fast, flexible and pragmatic, PHP powers everything from your
blog to the most popular websites in the world.

## Getting start

### Daemon

When running docker image as a daemon, the `/run/init/start` shell script is executed at startup.

```bash
user@host:$ docker run -d -it --name ${my_container_name} -v "${host_path}:/var/www/html" zaioll/php-zts:${php_version}
```

To share the socket file, create shared volume first:

```bash
user@host:$ docker volume create sock
```

Then, run the container passing the created shared volume.

```bash
user@host:$ docker run -d -it -v "sock:/run/php" -v "${host_path}:/var/www/html" --name ${my_container_name} zaioll/php-zts:${php_version}
```

> The `/run/init/hook-start` shell script is called at the end of `/run/init/start` running process and before start `supervisord`. Add your custom shell script commands into it to run it.

### Interactive

When running docker image as a iteractive form, the `/run/init/start` shell script is not executed. Then, PHP-FPM is not started. It needs manual run.



### Configuration with environment variables

- `APP_ENV` = ( ^dev* | ^prod* | debug ) Default: `dev`
    - Main diretive to configure the entire environment. When **APP_ENV** is configured with "dev" value, the **xdebug** will be enabled and configured and PHP (and webserver if it's enabled) default *timeouts* and *time limits* will be incresead at **8 times**. On the other hand, if **APP_ENV** is configured with "prod" value, the **opcache** will be enabled and configured. PHP defaults values for *timeouts* will be decreased to 10% of the default values.

        - Default overwritten prod PHP config:

            ```bash
            PHP_INI="
                cgi.fix_pathinfo=0
                display_startup_errors=Off
                memory_limit=${memory_limit}M
                zend.assertions=-1
                report_memleaks=Off
                display_errors=Off
                log_errors=Off
                expose_php=Off
                max_execution_time=${max_execution_time}
                date.time_zone=America/Manaus
                session.cookie_secure=On"
            ```

        - Default overwritten dev PHP config:

            ```bash
            PHP_INI="
                cgi.fix_pathinfo=0
                display_startup_errors=On
                implicit_flush=On
                memory_limit=${memory_limit}M
                display_errors=On
                log_errors=On
                expose_php=On
                max_execution_time=${max_execution_time}
                date.time_zone=America/Manaus
                session.cookie_secure=Off"
            ```

- `PHP_FPM_SOCKET`=( off | on ) Default: `on`
    - To enable PHP-FPM socket, set `ENABLE_FPM_SOCKET` env var to `on` to create and communicate through unix socket file **/run/php/php7-fpm.sock** or set to `off` for communication through **tcp/9000** port instead.
- `WEB_SERVER`=( on | off ) Default: `on`
- `OPCACHE_CONF`=( off | \$config ) Default: `$config` when prod environment
- [`XDEBUG_CONFIG`](https://xdebug.org/docs/remote) = ( off | \$config ) Default: `$config` when dev environment
    - If Xdebug is enabled, the PHP-FPM expects xdebug
    configuration through `XDEBUG_CONFIG` env var.
    > If `ENABLE_FPM_SOCKET` = "off", **xdebug.remote_port** will be configured to use **9003** port.

- `REDIS`=( on | off ) Default: `off`
- `ENABLE_MEMCACHED`=( on | off ) Default: `off`
- `ENABLE_PARALLEL`=( on | off ) Default: `on`
- `ENABLE_MONGODB`=( on | off ) Default: `off`
- `ENABLE_SWOOLE`=( on | off ) Default: `off`
- `ENABLE_AMQP`=( on | off ) Default: `off`
- `ENABLE_SODIUM`=( on | off ) Default: `on`
- `ENABLE_DECIMAL`=( on | off ) Default: `on`

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
    <minor>                   ::= "1" | "2" | "3" | "4"
    <patch>                   ::=  ( "0" | [1-9] [0-9]*)


## Features

- [Composer 2.X](https://getcomposer.org/) for dependency management in PHP.
- Nginx and Apache2 webservers
- [PhpBench](https://github.com/phpbench/phpbench) tool.
- [Phive](https://phar.io/)

### Modules

- [Parallel](https://https://github.com/krakjoe/parallel.git)
- [Swoole](https://www.swoole.co.uk/)
- [Decimal](https://php-decimal.io/)
- [Xdebug](https://github.com/xdebug/xdebug.git)
- [Memcached](https://github.com/php-memcached-dev/php-memcached.git)
- [Mongodb](https://github.com/mongodb/mongo-php-driver.git)
- [Redis](https://github.com/phpredis/phpredis.git)
- [Sodium]
- [PHP AMQP](https://github.com/php-amqp/php-amqp)

### Installed libs and extensions

Inside `/info/` directory are compile and info logs files

- [Installed Libs](benckmarks/installed-libs.md)
- [Installed PHP extensions](benckmarks/installed-php-extensions.md)

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
