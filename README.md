# rathorian/transmission

[![](https://github.com/rathorian/transmission/workflows/build/badge.svg)](https://github.com/rathorian/transmission/actions)
[![](https://img.shields.io/docker/pulls/rathorian/transmission)](https://hub.docker.com/r/rathorian/transmission)
[![](https://img.shields.io/docker/stars/rathorian/transmission)](https://hub.docker.com/r/rathorian/transmission)

## Features

 - Platform image: `linux/amd64`, `linux/arm64`
 - Based on Alpine Linux 3.19
 - No root process
 - WebUI available for use: [TrguiNG](https://github.com/openscopeproject/TrguiNG)

## Build image

### Build arguments

| Argument | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **TRGUING_VERSION** | TrguiNG version | *optional* | 1.1.0

### build

```sh
docker build --tag rathorian/transmission:latest https://github.com/Rathorian/transmission.git
```

### Build with arguments

```sh
docker build --tag rathorian/transmission:latest --build-arg TRGUING_VERSION=1.1.0 https://github.com/Rathorian/transmission.git
```

## Configuration

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **PUID** | Choose uid for transmission launch | *optional* | 1000
| **PGID** | Choose gid for transmission launch | *optional* | 1000
| **TZ** | Setting the timezone | *optional* | Europe/Paris
| **PEER_PORT** | Peer port | *optional* | 51413
| **TRANSMISSION_WEB_HOME** | Choose your WebUI | *optional* | /trguing

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
  -e PEER_PORT=51413 \
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
      - "PEER_PORT=51413"
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