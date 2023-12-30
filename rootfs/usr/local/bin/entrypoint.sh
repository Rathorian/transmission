#!/usr/bin/env sh

CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
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
    "ERR")
      echo -e "${CRED}[$(date +%Y/%m/%d-%H:%M:%S)] ${LOG_MESSAGE}${CEND}"
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
if [ ! -f /config/settings.json ]; then
  cp /defaults/settings.json /config/settings.json
fi
f_log SUC "Done"

if [ -n "${TRANSMISSION_WEB_HOME}" ] && [ "${TRANSMISSION_WEB_HOME}" = "/flood-for-transmission" ]; then
  if [ -d /trguing ]; then
    rm -rf /trguing
  fi
  f_log INF "Installing WebUI : flood-for-transmission... "
  mkdir -p /flood-for-transmission
  cd /flood-for-transmission
  wget https://github.com/johman10/flood-for-transmission/releases/download/latest/flood-for-transmission.tar.gz -O /flood-for-transmission/flood-for-transmission.tar.gz >> /tmp/webui.log 2>&1
  tar -xf flood-for-transmission.tar.gz --strip-components=1
  rm -rf flood-for-transmission.tar.gz
  chown -R "${PUID}:${PGID}" /flood-for-transmission
  f_log SUC "Done"
elif [ -n "${TRANSMISSION_WEB_HOME}" ] && [ "${TRANSMISSION_WEB_HOME}" = "/trguing" ]; then
  if [ -d /flood-for-transmission ]; then
    rm -rf /flood-for-transmission
  fi
  f_log INF "Installing WebUI : TrguiNG... "
  mkdir -p /trguing
  cd /trguing
  wget https://github.com/openscopeproject/TrguiNG/releases/download/v${TRGUING_VERSION}/trguing-web-v${TRGUING_VERSION}.zip -O /trguing/trguing-web-v${TRGUING_VERSION}.zip >> /tmp/webui.log 2>&1
  unzip trguing-web-v${TRGUING_VERSION}.zip >> /tmp/webui.log 2>&1
  rm -rf trguing-web-v${TRGUING_VERSION}.zip
  chown -R "${PUID}:${PGID}" /trguing
  f_log SUC "Done"
fi

f_log INF "Assigning torrent user rights... "
chown -R "${PUID}:${PGID}" /defaults /config /transmission
f_log SUC "Done"

exec su-exec "${PUID}:${PGID}" "$@"