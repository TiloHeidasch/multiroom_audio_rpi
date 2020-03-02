#!/bin/bash

# Raspotify Install
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh &&

# Snapserver install
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapserver_0.17.1-1_armhf.deb &&
sudo dpkg -i --force-all snapserver_0.17.1-1_armhf.deb &&
sudo apt-get -f install -y &&

# Configure Raspotify
echo 'DEVICE_NAME="HOME" 
BITRATE="320" 
BACKEND_ARGS="--backend pipe --device /tmp/snapfifo"' | sudo tee /etc/default/raspotify

# Configure Snapserver
sudo cp config/snapserver.conf /etc/snapserver.conf

# Create Service routine
echo "[Unit]
Description=Multiroom Audio RPi Server Service

[Service]
Type=simple
ExecStart=snapserver

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/multiroom_audio_rpi_server.service

# Start new service routine
sudo systemctl enable multiroom_audio_rpi_server.service

# Reboot Raspotify
sudo systemctl restart raspotify.service

# Start new service routine
sudo systemctl start multiroom_audio_rpi_server.service

# Cleanup
sudo rm snapserver_0.17.1-1_armhf.deb
