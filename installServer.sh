#!/bin/bash

# Raspotify Install
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh &&

# Snapserver install
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapserver_0.17.1-1_armhf.deb &&
sudo dpkg -i --force-all snapserver_0.17.1-1_armhf.deb &&
sudo apt-get -f install -y &&

# Bluetooth Install
wget -q https://github.com/nicokaiser/rpi-audio-receiver/archive/master.zip
unzip master.zip
rm master.zip

cd rpi-audio-receiver-master
./install.sh
cd ..

# Configure Bluetooth
## Add Bluetooth User
sudo adduser blueaudio
## Add to all groups
sudo usermod -a -G adm
sudo usermod -a -G dialout
sudo usermod -a -G cdrom
sudo usermod -a -G sudo
sudo usermod -a -G audio
sudo usermod -a -G video
sudo usermod -a -G plugdev
sudo usermod -a -G games
sudo usermod -a -G users
sudo usermod -a -G input
sudo usermod -a -G netdev
sudo usermod -a -G spi
sudo usermod -a -G gpio

## Configure a2dp agent to use blueaudio
echo "[Unit]
Description=Bluetooth A2DP Agent
Requires=bluetooth.service
After=bluetooth.service

[Service]
ExecStart=/usr/local/bin/a2dp-agent.py
RestartSec=5
Restart=always
User=blueaudio

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/a2dp-agent.service

## Configure Aplay Service to use blueaudio
echo "[Unit]
Description=BlueALSA aplay
Requires=bluealsa.service
After=bluealsa.service sound.target

[Service]
Type=simple
User=root
ExecStartPre=/bin/sleep 2
ExecStart=/usr/bin/bluealsa-aplay --pcm-buffer-time=250000 00:00:00:00:00:00
RestartSec=5
Restart=always
User=blueaudio

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/bluealsa-aplay.service

## Disable Onboard Bluetooth
echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt


# Configure Raspotify
echo 'DEVICE_NAME="HOME" 
BITRATE="320" 
BACKEND_ARGS="--backend pipe --device /tmp/snapfifo"' | sudo tee /etc/default/raspotify

# Configure Snapserver
echo 'SNAPSERVER_OPTS="-d"' | sudo tee /etc/default/snapserver

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