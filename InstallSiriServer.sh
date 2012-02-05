#!/bin/bash

# This script is designed for OSX but will probably run on Linux aswell
# if you have the python-setuptools install (apt-get install otherwise)
#
# 64-bit version (if you're running 32-bit delete the "--disable-asm-opt.."
#
# This script will download all necessary dependencies 
# both for audio handling and for python
# Then it will proceed to fetch the SiriServer from 
# Github and install it, it will then proceed
# and generate SSL-certs for both the server and client
# Remeber to run Script as root as the installation will fail otherwise
# Author of installation script johanberglind
# I am not the author nor the creator of the server
#

mkdir tempfolder
cd tempfolder
# Checks for libogg package and if it's already installed scripts moves on to libspeex
echo "Checking if Libogg is installed"
if [ -f /usr/local/lib/libogg.a ]
then echo "Libogg is already installed, proceeding to next step"
else echo "Not installed, downloading libogg"
curl http://downloads.xiph.org/releases/ogg/libogg-1.3.0.zip > libogg-1.3.0.zip
unzip libogg-1.3.0.zip
cd libogg-1.3.0
echo "Installing libogg"
./configure
make
sudo make install
fi
# Checks for libspeex and if it's already installed the scripts moves on to checking for flac
echo "Checking if Libspeex is installed"
if [ -f /usr/local/lib/libspeex.a ]
then echo "Libspeex is already installed, proceeding to next step"
else echo "Not installed, downloading Libspeex"
curl http://downloads.xiph.org/releases/speex/speex-1.2rc1.tar.gz > speex-1.2rc1.tar.gz
clear
echo "Download complete, unzipping"
tar -xf speex-1.2rc1.tar.gz
cd speex-1.2rc1
clear
# Installing Speex.."
echo "Installing Speex..."
./configure
make
sudo make install
fi
cd ..
clear
# Checks for FLAC and if it's already installed the scripts moves on
echo "Checking for Flac..."
if [ "$(which flac)" != "" ]
then echo "FLAC is already installed, proceeding to next step"
else curl -L http://sourceforge.net/projects/flac/files/flac-src/flac-1.2.1-src/flac-1.2.1.tar.gz/download > flac-1.2.1.tar.gz
clear
echo "Download complete, unzipping"
tar -xf flac-1.2.1.tar.gz
clear
echo "Installing Libflac.."
cd flac-1.2.1
./configure --disable-asm-optimizations
make
sudo make install
fi
cd ..
cd ..
clear
# Downloading and installing necessary python packages if they're not already installed
echo "Installing Python-packages"
sudo easy_install biplist
sudo easy_install M2Crypto
clear
echo "Python installation complete"
echo "Downloading SiriServer from Github..."
curl -L https://github.com/Eichhoernchen/SiriServer/tarball/master >> siriserver.tar.gz
clear
echo "Unzipping"
tar -xf siriserver.tar.gz && cd Eich*
cd gen_certs/
clear
echo "Time to generate SSL-certs, what is the IP of the Siriserver (this computer)?"
read IP
./gen_certs.sh $IP
clear
cd ..
cp ca.pem ~/Desktop/
clear
echo "Ok, now you need to transfer the ca.pem file to your iOS device"
echo "I've copied the file to your desktop for easy access"
echo "The easiest way is to mail it to yourself and open it on your iOS device"
read -p "Press [ENTER] to continue to the next step when you've installed it"
clear
echo "(NON 4S ONLY) Go ahead and download Spire from Cydia"
echo "That should take a while, but once you're done enter your IP in"
echo "the settings page of Spire: $IP"
read -p "Press [ENTER] to continue to the next step"
clear
echo "Starting Siriserver..."
echo "Now go ahead and enable Siri in the general-tab in the Settings-app"
echo "If everything went smooth, you should be up and running"
echo "Try saying: Hello Siri"
echo "Press CTRL+C to STOP"
sudo python siriServer.py