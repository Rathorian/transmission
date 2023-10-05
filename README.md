# rathorian/transmission

[![](https://github.com/rathorian/transmission/workflows/build/badge.svg)](https://github.com/rathorian/transmission/actions)
[![](https://img.shields.io/docker/pulls/rathorian/transmission)](https://hub.docker.com/r/rathorian/transmission)
[![](https://img.shields.io/docker/stars/rathorian/transmission)](https://hub.docker.com/r/rathorian/transmission)

## Features

 - Platform image: `linux/amd64`, `linux/arm64`
 - Based on Alpine Linux 3.18
 - No root process
 - Selectable transmission web user interface: Default, [Flood for Transmission](https://github.com/johman10/flood-for-transmission), [TrguiNG](https://github.com/openscopeproject/TrguiNG)

## Configuration

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **PUID** | Choose uid for transmission launch | *optional* | 1000
| **PGID** | Choose gid for transmission launch | *optional* | 1000
| **TZ** | Setting the timezone | *optional* | Europe/Paris
| **TRANSMISSION_WEB_HOME** | Choose your WebUI | *optional* | default

#### Usage TRANSMISSION_WEB_HOME

 - `/config/flood-for-transmission` : value to use for flood-for-transmission
 - `/config/trguing` : value to use for trguing

 If the TRANSMISSION_WEB_HOME variable is not defined, the WebUI used by default will be that of Transmission.

### Volumes

 - `/config` : folder for transmission configuration
 - `/transmission` : folder for download torrents

#### Data folder tree

 - `/config/settings.json` : configuration file for transmission
 - `/transmission/downloads` : torrent download folder
 - `/transmission/incomplete` : temporary folder for incomplete torrents
 - `/transmission/watch` : folder for manual additions of torrents and which will automatically start the download

### Ports

 - `9091` : RPC-PORT
 - `51413` : PEER-PORT

## Usage

### Simple launch

```sh
docker run --name transmission -dt \
  --restart unless-stopped \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /mnt/docker/transmission/config:/config \
  -v /mnt/docker/transmission/data:/transmission \
  rathorian/transmission:latest
```

URL: http://xx.xx.xx.xx:9091

### Docker-compose

```sh
version: "3.8"
services:
  transmission:
    image: "rathorian/transmission:latest"
    container_name: "transmission"
    restart: "unless-stopped"
    environment:
      - "PUID=1000"
      - "PGID=1000"
      - "TZ=Europe/Paris"
    volumes:
      - "/mnt/docker/transmission/config:/config"
      - "/mnt/docker/transmission/data:/transmission"
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
```

URL: http://xx.xx.xx.xx:9091

## License

Docker image [rathorian/transmission](https://hub.docker.com/r/rathorian/transmission) is released under [MIT License](https://github.com/Rathorian/transmission/blob/main/LICENSE).