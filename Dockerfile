FROM zaioll/debian:stretch

LABEL maintener 'Láyro Cristofér <zaioll@protonmail.com>'

ENV php_version=7.4

COPY install /install/
RUN /install/_install.sh

COPY configure /configure/
RUN /configure/_run.sh

ENV ENABLE_FPM_SOCKET=1
ENV ENABLE_XDEBUG=1

STOPSIGNAL SIGTERM
CMD ["/bin/bash", "/run/start.sh"]