FROM zaioll/debian:stretch

LABEL maintener 'Láyro Cristofér <zaioll@protonmail.com>'

ENV VERSION=7.2
ENV FPM_SOCKET=1

COPY install /install/
RUN /install/_install.sh

COPY run /run/
RUN /run/_run-preload.sh
RUN /run/_run.sh

STOPSIGNAL SIGTERM
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]