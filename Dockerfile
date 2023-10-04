FROM alpine:3.18

LABEL description="Transmission based on Alpine Linux" \
      maintainer="Rathorian <contact@psn-nw.fr>"

ENV PUID=1000 \
    PGID=1000 \
    TZ=Europe/Paris \
    TRANSMISSION_WEB_HOME=

RUN apk add --update --no-cache \
    su-exec \
    transmission-daemon \
    tzdata

COPY rootfs /

RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /config /transmission

EXPOSE 9091 51413 51413/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/sh", "-c", "/usr/bin/transmission-daemon --foreground --config-dir /config"]