FROM alpine:3.19

LABEL description="Transmission based on Alpine Linux" \
      maintainer="Rathorian <contact@psn-nw.fr>"

ENV PUID=1000 \
    PGID=1000 \
    TZ=Europe/Paris \
    PEER_PORT=51413 \
    TRGUING_VERSION=1.1.0

RUN apk add --update --no-cache \
    su-exec \
    transmission-daemon \
    tzdata

COPY rootfs /

RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /config /transmission

EXPOSE 9091 ${PEER_PORT} ${PEER_PORT}/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]