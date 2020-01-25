# multiroom_audio_rpi

<p>This is a multiroom audio setup for the rasperry pi, which enables you to stream spotify music to several rasperry pis in your network</p>

<p>This is tested using raspian buster lite (https://www.raspberrypi.org/downloads/raspbian/) on the rasperry pi 3 and the raspberry pi B+</p>
<p>Remember to setup wifi and ssh on your RPi: https://www.raspberrypi.org/documentation/configuration/wireless/headless.md</p>

## Intallation
### Install git:
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get -f install -y git

### Download this repository:
git clone https://github.com/TiloHeidasch/multiroom_audio_rpi

### Install Server:
sudo ./installServer.sh

### Install Client
sudo ./installClient.sh aaa.bbb.ccc.ddd
Provide server IP in aaa.bbb.ccc.ddd

## Credits
<p>This multiroom audio setup for the rasperry pi was initially inspired by <a href='https://github.com/mariolukas/HydraPlay'>Hydraplay</a></p>

<p>It is using <a href='https://github.com/dtcooper/raspotify'>raspotify</a> and <a href='https://github.com/badaix/snapcast'>snapcast</a> to enable spotify multiroom audio.</p>

<p>Further more this was inspired by following threads: https://github.com/badaix/snapcast/issues/425 and https://github.com/dtcooper/raspotify/issues/30</p>