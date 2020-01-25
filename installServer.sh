#!/bin/bash

#====================RASPOTIFY INSTALL==========
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh &&

#====================SNAPSERVER INSTALL==========
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapserver_0.17.1-1_armhf.deb &&
sudo dpkg -i --force-all snapserver_0.17.0-1_armhf.deb &&
sudo apt-get -f install -y &&

#====================CONFIGURE RASPOTIFY==========
echo 'DEVICE_NAME="ALL" 
BITRATE="320" 
BACKEND_ARGS="--backend pipe --device /tmp/snapfifo"' | sudo tee -a /etc/default/raspotify

#====================CONFIGURE SNAPSERVER==========
echo 'SNAPSERVER_OPTS="-d -s spotify:///librespot?name=spotify&bitrate=320"' | sudo tee /etc/default/snapserver

#====================REBOOT RASPOTIFY==============
sudo systemctl restart raspotify.service