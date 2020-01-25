#!/bin/sh

sudo apt-get update
sudo apt-get upgrade
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapclient_0.17.1-1_armhf.deb
sudo dpkg -i snapclient_0.17.1-1_armhf.deb
sudo apt-get -f install -y
sudo apt-get install -y\
	alsa-utils \
	libasound2 \
	libasound2-plugins \
	pulseaudio \
	pulseaudio-utils \
	libavahi-client-dev \
	--no-install-recommends
sudo cp ./config/default.pa /etc/pulse/default.pa