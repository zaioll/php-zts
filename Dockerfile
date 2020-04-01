FROM zaioll/debian:stretch

LABEL maintener 'Láyro Chrystofer <zaioll@protonmail.com>'

ENV php_version=7.4

COPY install /install/
RUN /install/_install.sh

COPY configure /configure/
RUN /configure/_run.sh

STOPSIGNAL SIGTERM
CMD ["/bin/bash", "/run/start.sh"]