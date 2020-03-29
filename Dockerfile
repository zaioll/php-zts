FROM zaioll/debian:stretch

LABEL maintener 'Láyro Cristofér <zaioll@protonmail.com>'

ENV FPM_SOCKET=1
ENV php_version=7.4

COPY install /install/
RUN /install/_install.sh

COPY configure /configure/
RUN /configure/_run.sh

STOPSIGNAL SIGTERM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]