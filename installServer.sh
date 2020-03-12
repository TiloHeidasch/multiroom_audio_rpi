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
echo "pcm.!default {
        type plug
        slave.pcm rate48000Hz
}

pcm.rate48000Hz {
        type rate
        slave {
                pcm writeFile # Direct to the plugin which will write to a file
                format S16_LE
                rate 48000
        }
}

pcm.writeFile {
        type file
        slave.pcm null
        file "/tmp/bluesnapfifo"
        format "raw"
}
" | sudo tee /home/blueaudio/.asoundrc 

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