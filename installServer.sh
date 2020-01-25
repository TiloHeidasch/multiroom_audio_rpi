#!/bin/bash

#====================RASPOTIFY INSTALL==========
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh &&

#====================SNAPSERVER INSTALL==========
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapserver_0.17.1-1_armhf.deb &&
sudo dpkg -i --force-all snapserver_0.17.1-1_armhf.deb &&
sudo apt-get -f install -y &&

#====================CONFIGURE RASPOTIFY==========
echo 'DEVICE_NAME="HOME" 
BITRATE="320" 
BACKEND_ARGS="--backend pipe --device /tmp/snapfifo"' | sudo tee /etc/default/raspotify

#====================CONFIGURE SNAPSERVER==========
echo 'SNAPSERVER_OPTS="-d -s spotify:///librespot?name=spotify&bitrate=320"' | sudo tee /etc/default/snapserver

#===========CREATE SERVICE ROUTINE============
echo "[Unit]
Description=Multiroom Audio RPi Server Service

[Service]
Type=simple
ExecStart=snapserver

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/multiroom_audio_rpi_server.service

#===============START NEW SERVICE ROUTINE===========
sudo systemctl enable multiroom_audio_rpi_server.service

#====================REBOOT RASPOTIFY==============
sudo systemctl restart raspotify.service

#===============START NEW SERVICE ROUTINE===========
sudo systemctl start multiroom_audio_rpi_server.service