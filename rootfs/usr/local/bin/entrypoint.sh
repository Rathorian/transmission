#!/usr/bin/env sh

CSI="\033["
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"
CBLUE="${CSI}1;34m"

f_log() {
  LOG_TYPE="${1}"
  LOG_MESSAGE="${2}"

  case "${LOG_TYPE}" in
    "INF")
      echo -en "${CBLUE}[$(date +%Y/%m/%d-%H:%M:%S)] ${LOG_MESSAGE}${CEND}"
    ;;
    "SUC")
      echo -e "${CGREEN}${LOG_MESSAGE}${CEND}"
    ;;
  esac
}

f_log INF "Setting the timezone... "
cp /usr/share/zoneinfo/${TZ} /etc/localtime
echo "${TZ}" > /etc/timezone
f_log SUC "Done"

f_log INF "Creating group for torrent user... "
if [ -z "$(grep :${PGID}: /etc/group | cut -f 3 -d :)" ]; then
  addgroup -g "${PGID}" torrent
fi
f_log SUC "Done"

f_log INF "Create torrent user... "
if [ -z "$(grep :${PUID}: /etc/passwd | cut -f 3 -d :)" ]; then
  adduser -S -D -h /transmission -s /sbin/nologin -G torrent -u "${PUID}" -g torrent torrent
fi
f_log SUC "Done"

f_log INF "Create volume folders... "
mkdir -p /transmission/downloads /transmission/incomplete /transmission/watch /config
f_log SUC "Done"

f_log INF "Copying the Transmission configuration file... "
if [ ! -e /config/settings.json ]; then
  cp /defaults/settings.json /config/settings.json
fi
f_log SUC "Done"

f_log INF "Assigning torrent user rights... "
chown -R "${PUID}":"${PGID}" /defaults /config /transmission /trguing
f_log SUC "Done"

exec su-exec "${PUID}":"${PGID}" /usr/bin/transmission-daemon --foreground --config-dir /config --peerport "${PEER_PORT}"