FROM alpine:3.19

LABEL description="Transmission based on Alpine Linux" \
      maintainer="Rathorian <contact@psn-nw.fr>"

ARG TRGUING_VERSION=1.1.0

ENV PUID=1000 \
    PGID=1000 \
    TZ=Europe/Paris \
    PEER_PORT=51413 \
    TRANSMISSION_WEB_HOME=/trguing

RUN apk add --update --no-cache \
    su-exec \
    transmission-daemon \
    tzdata \
    unzip \
    wget \
    # Install WebUI : TrguiNG
    && mkdir /trguing \
    && wget https://github.com/openscopeproject/TrguiNG/releases/download/v${TRGUING_VERSION}/trguing-web-v${TRGUING_VERSION}.zip -O /trguing/trguing-web.zip \
    && unzip /trguing/trguing-web.zip \
    && rm -rf /trguing/trguing-web.zip

COPY rootfs /

RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /config /transmission

EXPOSE 9091 ${PEER_PORT} ${PEER_PORT}/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]