FROM zaioll/debian:stretch

LABEL maintener 'Láyro Chrystofer <zaioll@protonmail.com>'

ENV php_version=8.0
ENV usuario developer
ENV HOME "/home/${usuario}"

COPY install/requirements /install/requirements
RUN /install/requirements/pre-install

COPY install/download /install/
RUN /install/download

COPY install/packages /install/packages
RUN /install/packages/install

COPY configure /configure/
RUN /configure/_run.sh

COPY install/requirements/_dev-packages /install/requirements/
COPY install/post-install /install/
RUN /install/post-install

STOPSIGNAL SIGTERM
CMD ["/bin/bash", "/run/start.sh"]