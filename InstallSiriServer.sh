#!/bin/bash
# This script will download all necessary dependencies (and curl)
# both for audio handling and for python
# Then it will proceed to fetch the SiriServer from 
# Github and install it, it will then proceed
# and generate SSL-certs for both the server and client
# Remeber to run Script as root as the installation will fail otherwise
# Author of installation script johanberglind
# I am not the author nor the creator of the server
#

## Checking wether 64 or 32 bit system to use for flac compilation
VERSION=`uname -a | grep "x86_64"`

mkdir tmp
cd tmp
echo "--------- SiriServer Installation Script --------"
echo "If you don't have any of the dependencies installed the script will take a while to finish"
read -p "Expect atleast 1-2 minutes, Press [ENTER] if you're ready to continue"
clear
if [ "$(which curl)" != "" ]; then 
  echo "Curl is already installed, proceeding"
else 
  echo "Downloading and installing Curl"
  wget http://curl.haxx.se/download/curl-7.24.0.tar.gz
  tar -xf curl-7.24.0.tar.gz
  cd curl-7.24.0
  ./configure
  make
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
if [ "$(which git)" != "" ]; then 
  echo "Git is already installed, proceeding"
else
  echo "Scraping Git's latest stable release version number off the home page"
  LSR_NUM=$(curl -silent http://git-scm.com/ | sed -n '/id="ver"/ s/.*v\([0-9].*\)<.*/\1/p')

  echo "Downloading & unpacking Git's latest stable release: git-$LSR_NUM"
  curl http://kernel.org/pub/software/scm/git/git-$LSR_NUM.tar.gz | tar -xz
  tar xzf git-$LSR_NUM.tar.gz
  cd git-$LSR_NUM
  ./configure --prefix=/usr/local
  make all
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
if [ "$(which openssl)" != "" ]; then 
  echo "OpenSSL is already installed, proceeding"
else 
  echo "Downloading and installing OpenSSL"
  curl http://www.openssl.org/source/openssl-1.0.0g.tar.gz > openssl-1.0.0g.tar.gz
  tar -xf openssl-1.0.0g.tar.gz
  cd openssl-1.0.0g
  ./config
  make
  make test
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
# Checks for libogg package and if it's already installed scripts moves on to libspeex
echo "Checking if Libogg is installed [10%--------]"
if [ -f /usr/local/lib/libogg.a ]; then 
  echo "Libogg is already installed, proceeding to next step"
else 
  echo "Not installed, downloading libogg"
  curl http://downloads.xiph.org/releases/ogg/libogg-1.3.0.zip > libogg-1.3.0.zip
  unzip libogg-1.3.0.zip
  cd libogg-1.3.0
  echo "Installing libogg"
  ./configure
  make
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
# Checks for libspeex and if it's already installed the scripts moves on to checking for flac
echo "Checking if Libspeex is installed  [-20%--------]"
if [ -f /usr/local/lib/libspeex.a ]; then 
  echo "Libspeex is already installed, proceeding to next step"
else 
  echo "Not installed, downloading Libspeex"
  curl http://downloads.xiph.org/releases/speex/speex-1.2rc1.tar.gz > speex-1.2rc1.tar.gz
  clear
  echo "Download complete, unzipping"
  tar -xf speex-1.2rc1.tar.gz
  cd speex-1.2rc1
  clear
  # Installing Speex.."
  echo "Installing Speex... [--30%------]"
  ./configure
  make
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
# Checks for FLAC and if it's already installed the scripts moves on
echo "Checking for Flac…  [----50%----]"
if [ "$(which flac)" != "" ]; then 
  echo "FLAC is already installed, proceeding to next step"
else 
  curl -L http://sourceforge.net/projects/flac/files/flac-src/flac-1.2.1-src/flac-1.2.1.tar.gz/download > flac-1.2.1.tar.gz
  clear
  echo "Download complete, unzipping"
  tar -xf flac-1.2.1.tar.gz
  clear
  echo "Installing Libflac.. [-----60%---]"
  cd flac-1.2.1
  if [ -n "$VERSION" ]; then
    echo "64 bit system"
    ./configure --disable-asm-optimizations
  else
    echo "32 bit system, not using \"--disable-asm-optimizations\""
    ./configure
  fi
  make
  sudo make install
  cd ..
fi
read -p "Press [ENTER] to continue"
clear
echo -e "Would you like to delete the \"temporary items\" folder? [y/n]"
read answer
if [ "$answer" == "y" ]; then 
  echo "Deleting temporary items..."
  cd ../
  sudo rm -rf tmp
else
  echo "Temporary items left in /tmp folder"
fi
read -p "Press [ENTER] to continue"
clear
# Downloading and installing necessary python packages and easy_install if they're not already installed
echo "Installing easy_install"
if [ "$(which easy_install)" != "" ]; then 
  echo "easy_install is installed, proceeding"
else 
  echo "Downloading and installing easy_install"
  curl http://pypi.python.org/packages/2.3/s/setuptools/setuptools-0.6c11-py2.3.egg#md5=2baeac6e13d414a9d28e7ba5b5a596de > setuptools-0.6c11-py2.3.egg
  sh setuptools-0.6c11-py2.3.egg
  clear
  curl http://pypi.python.org/packages/2.4/s/setuptools/setuptools-0.6c11-py2.4.egg#md5=bd639f9b0eac4c42497034dec2ec0c2b > setuptools-0.6c11-py2.4.egg
  sh setuptools-0.6c11-py2.4.egg
  clear
  curl http://pypi.python.org/packages/2.5/s/setuptools/setuptools-0.6c11-py2.5.egg#md5=64c94f3bf7a72a13ec83e0b24f2749b2 > setuptools-0.6c11-py2.5.egg
  sh setuptools-0.6c11-py2.5.egg
  clear
  curl http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg#md5=bfa92100bd772d5a213eedd356d64086 > setuptools-0.6c11-py2.6.egg
  sh setuptools-0.6c11-py2.6.egg
  clear
  curl http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg#md5=fe1f997bc722265116870bc7919059ea > setuptools-0.6c11-py2.7.egg
  sh setuptools-0.6c11-py2.7.egg
  clear
fi
clear
echo "Installing Python-packages [------70%--]"
sudo easy_install biplist
sudo easy_install M2Crypto
clear
echo "Python installation complete"
read -p "Press [ENTER] to continue"
echo -e "Would you like to install all the plugin dependencies? [y/n] "
read answer
if [ "$answer" == "y" ]; then 
  echo "Installing jsonrpclib ... "
  sudo easy_install jsonrpclib
  echo "Installing wordnik ... "
  sudo easy_install wordnik
else
  echo "Note that when not installing those dependencies, some plugins might not work as expected"
fi
read -p "Press [ENTER] to continue"
clear
echo "Cloning SiriServer from Github... [---------80%-]"
git clone git://github.com/Eichhoernchen/SiriServer.git
clear
cd Siri*
cd gen_certs/
clear
echo "Time to generate SSL-certs, what is the IP of the Siriserver (this computer)? [----------90%]"
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
echo "the settings page of Spire: https://$IP"
read -p "Press [ENTER] to continue to the next step  [100%]"
clear
echo "Starting Siriserver..."
echo "Now go ahead and enable Siri in the general-tab in the Settings-app"
echo "If everything went smooth, you should be up and running"
echo "Try saying: Hello Siri"
echo "Press CTRL+C to STOP"
sudo python siriServer.py