# multiroom_audio_rpi

This is a multiroom audio setup for the rasperry pi, which enables you to stream spotify music to several rasperry pis in oyur network

This is tested using raspian buster lite (https://www.raspberrypi.org/downloads/raspbian/) on the rasperry pi 3 and the raspberry pi B+
Remember to setup wifi and ssh on your RPi: https://www.raspberrypi.org/documentation/configuration/wireless/headless.md

## Intallation
### Install git:
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get -f install -y git

### Download this repository:
git clone https://github.com/TiloHeidasch/multiroom_audio_rpi

### Install Server:
sudo ./installServer.sh

### Install Client
sudo ./installServer.sh

## Run
### Server
snapserver
### Client
sudo ./runClient.sh <specify server address>
### Server + Client
snapserver & sudo ./runClient.sh 127.0.0.1

## Credits
This multiroom audio setup for the rasperry pi was initially inspired by Hydraplay: https://github.com/mariolukas/HydraPlay

It is using raspotify(https://github.com/dtcooper/raspotify) and snapcast(https://github.com/badaix/snapcast) to enable spotify multiroom audio.

Further more this was inspired by following threads: https://github.com/badaix/snapcast/issues/425 and https://github.com/dtcooper/raspotify/issues/30

