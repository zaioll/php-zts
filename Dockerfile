FROM --platform=amd64 zaioll/debian:buster-slim as build

LABEL maintener 'Láyro Chrystofer <zaioll@protonmail.com>'

ENV php_version=8.1
ENV usuario developer
ENV HOME "/home/${usuario}"

COPY install /install
COPY configure /configure

RUN /install/requirements/pre-install \
    && /install/download \
    && /install/packages/install \
    && /configure/_run.sh \
    && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y nginx \
    && /install/post-install

COPY init /run/init

STOPSIGNAL SIGTERM
CMD ["/bin/bash", "/run/init/start"]
