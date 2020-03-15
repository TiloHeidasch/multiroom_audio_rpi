#!/bin/bash

basepath=$(pwd)

# Make sure that the basepath has the correct ending
if [[ $basepath == *"multiroom_audio_rpi-master"* ]]; then
  echo "Path is Correct"
else
  echo "Path is incorrect. Trying to fix"
  basepath="$basepath/multiroom_audio_rpi-master"
fi

cd $basepath

# System Update
sudo apt-get update
sudo apt-get upgrade -y

# Raspotify Install
curl -sL https://dtcooper.github.io/raspotify/install.sh | sh &&

# Snapserver install
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapserver_0.17.1-1_armhf.deb &&
sudo dpkg -i --force-all snapserver_0.17.1-1_armhf.deb &&
sudo apt-get -f install -y &&

# Bluetooth Install
wget -q https://github.com/TiloHeidasch/rpi-audio-receiver/archive/master.zip
unzip master.zip
rm master.zip


cd rpi-audio-receiver-master
./install.sh
cd ..

# UI Install
wget -q https://github.com/TiloHeidasch/snapcast-websockets-ui/archive/master.zip
unzip master.zip
rm master.zip

# Configure Bluetooth
## Add Bluetooth User
sudo adduser --disabled-password --gecos "" blueaudio
## Add to all groups
sudo usermod -a -G adm blueaudio
sudo usermod -a -G dialout blueaudio
sudo usermod -a -G cdrom blueaudio
sudo usermod -a -G sudo blueaudio
sudo usermod -a -G audio blueaudio
sudo usermod -a -G video blueaudio
sudo usermod -a -G plugdev blueaudio
sudo usermod -a -G games blueaudio
sudo usermod -a -G users blueaudio
sudo usermod -a -G input blueaudio
sudo usermod -a -G netdev blueaudio
sudo usermod -a -G spi blueaudio
sudo usermod -a -G gpio blueaudio

## Configure alsa to reroute to file
sudo cp -r $basepath/server/home /home

## Disable Onboard Bluetooth
echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt

# Configure Snapserver
echo 'SNAPSERVER_OPTS="-d"' | sudo tee /etc/default/snapserver

# Copy server configuration
sudo cp $basepath/server/etc/snapserver.conf /etc/
sudo cp $basepath/server/etc/systemd/system/multiroom_audio_rpi_server.service /etc/systemd/system/
sudo cp $basepath/server/etc/systemd/system/bluealsa-aplay.service /etc/systemd/system/
sudo cp $basepath/server/home/blueaudio/.asoundrc /home/blueaudio

# Start new service routine
sudo systemctl enable multiroom_audio_rpi_server.service

# Disable Raspotify Service, since it is only here to provide librespot
sudo systemctl disable raspotify.service

# Start new service routine
sudo systemctl start multiroom_audio_rpi_server.service

# Cleanup
sudo rm snapserver_0.17.1-1_armhf.deb