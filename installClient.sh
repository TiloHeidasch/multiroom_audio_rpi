#!/bin/bash


#Valid IP courtesy of https://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
	exit 1
fi

if valid_ip $1; then
  echo "Good IP Supplied"; 
else 
  echo "$1 is not a valid_ip";
  exit 1;
fi

basepath=$(pwd)

### Make sure we are up to date
sudo apt-get update
sudo apt-get upgrade

### Downlaod the Snapclient
wget https://github.com/badaix/snapcast/releases/download/v0.17.1/snapclient_0.17.1-1_armhf.deb
sudo dpkg -i snapclient_0.17.1-1_armhf.deb
sudo apt-get -f install -y

### Install Dependancies
sudo apt-get install -y\
	alsa-utils \
	libasound2 \
	libasound2-plugins \
	pulseaudio \
	pulseaudio-utils \
	libavahi-client-dev \
	--no-install-recommends
	
### Configure Pulse
sudo cp ./config/default.pa /etc/pulse/default.pa

### Create service routine
echo "[Unit]
Description=Multiroom Audio RPi Client Service for $1

[Service]
Type=simple
ExecStart=$basepath/multiroom_audio_rpi/runClient.sh $1

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/multiroom_audio_rpi_client_$1.service

### Up the new service routine
sudo systemctl start multiroom_audio_rpi_client_$1.service