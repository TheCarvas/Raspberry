#!/bin/bash

sudo mkdir $HOME/kodi
sudo mkdir $HOME/kodi/home

sudo cat <<EOF > $HOME/Raspberry/kodi_containarized/docker-compose.yml
version: "3.7"
services:
  rpi-kodi:
    image: thecarvas/rpi-kodi
    build: .
    container_name: "kodi"
    user: kodi
    network_mode: host
    restart: always
    privileged: true
    devices:
      - /dev/fb0:/dev/fb0
      - /dev/vchiq:/dev/vchiq
    volumes:
      - /home/raspbian/kodi/home:/home/kodi
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
    tmpfs:
      - /tmp
    environment:
      - PULSE_SERVER=127.0.0.1
EOF

sudo mkdir $HOME/kodi/home/.kodi
sudo mkdir $HOME/kodi/home/.kodi/userdata/

sudo chmod a+w $HOME/kodi/home/.kodi/userdata/

sudo cat <<EOF > $HOME/kodi/home/.kodi/userdata/advancedsettings.xml
<advancedsettings>
    <services>
        <esallinterfaces>true</esallinterfaces>
        <webserver>true</webserver>
        <zeroconf>true</zeroconf>
    </services>
</advancedsettings>
EOF


sudo groupadd -g 9002 kodi
sudo useradd -u 9002 -r -g kodi kodi

sudo chown -R kodi:kodi $HOME/kodi/home