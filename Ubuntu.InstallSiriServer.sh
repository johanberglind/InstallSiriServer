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


echo "--------- SiriServer Installation Script --------"
echo "If you don't have any of the dependencies installed the script will take a while to finish"
read -p "Expect atleast 1-2 minutes, Press [ENTER] if you're ready to continue"
clear
if [ "$(which git)" != "" ]; then 
  echo "Git is already installed, proceeding"
else
  echo "Installing git-core package"
  sudo apt-get install git-core
fi
read -p "Press [ENTER] to continue"
clear
# Checks for libspeex and if it's already installed the scripts moves on to checking for flac
echo "Checking if Libspeex is installed  [-20%--------]"
if [ "$(locate libspeex)" != "" ]; then 
  echo "Libspeex is already installed, proceeding to next step"
else 
  echo "Installing Libspeex"
  sudo apt-get install libspeex1 
fi
read -p "Press [ENTER] to continue"
clear
# Checks for FLAC and if it's already installed the scripts moves on
echo "Checking for Flac…  [----50%----]"
if [ "$(locate flac)" != "" ]; then 
  echo "FLAC is already installed, proceeding to next step"
else 
  echo "Installing flac"
  sudo apt-get install libflac8 
fi
read -p "Press [ENTER] to continue"
clear
# Downloading and installing necessary python packages and easy_install if they're not already installed
echo "Installing easy_install"
if [ "$(which easy_install)" != "" ]; then 
  echo "easy_install is installed, proceeding"
else 
  echo "Installing python-setuptools"
  sudo apt-get install python-setuptools
fi
clear
echo "Installing Python-packages [------70%--]"
echo "Installing biplist"
sudo easy_install biplist
read -p "Press [ENTER] to continue"
echo "Installing M2Crypto"
sudo apt-get install python-M2Crypto
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