#!/bin/bash

# Menu script for the InstallSiriServer
# By johanberglind, it uses the update.sh script for updating from the
# Eichhoernchens Siriserver project

clear
tput setaf 2
if [ "$(whoami)" != "root" ]
then echo "NOTE: You're not running this as root, this will likely cause problems"
echo "Rerun with sudo ./menu.sh"
fi
tput sgr0
tput cup 3 15
tput setaf 3
echo "InstallSiriServer controlpanel v1.0"
tput sgr0
tput cup 5 15
tput setaf 1
echo "1. Install SiriServer"
tput sgr0
tput cup 6 15
tput setaf 1
echo "2. Update SiriServer"
tput sgr0
tput cup 7 15
tput setaf 1
echo "3. Generate SSL-certificates"
tput sgr0
tput cup 8 15
tput setaf 1
echo "4. Start SiriServer"
tput sgr0
tput cup 9 15
tput setaf 1
echo "5. Exit"
tput sgr0
tput cup 11 15
tput setaf 1
tput bold
read -p "Enter your choice (1-5): " CHOICE
if [ $CHOICE -eq 1 ]
then sudo sh ./InstallSiriServer.sh
sudo sh ./menu.sh
fi
if [ $CHOICE -eq 2 ]
then echo Updating...
clear
cd serverfolder
cd Eich*
sudo sh ./updateServer.sh
echo "Update complete, all files are up to date!"
read -p "Press [ENTER] to continue"
cd ..
cd ..
sudo ./menu.sh
fi
if [ $CHOICE -eq 4 ]
then echo "Starting Server..."
cd serverfolder/
cd Eich*
sudo python siriServer.py
cd ..
cd ..
sudo ./menu.sh
fi
if [ $CHOICE -eq 5 ]
then echo "Goodbye!" && exit
fi
if [ $CHOICE -eq 3 ]
then cd serverfolder/
cd Eich*
cd gen_certs
echo "Enter the IP of the Siriserver "
read SIP
sudo sh ./gen_certs.sh $SIP
cd ..
cp ca.pem ~/Desktop
cd ..
cd ..
clear
echo "The ca.pem should have been copied to your Desktop, otherwise you'll find it in the root of the server directory"
read -p "Press [ENTER] to continue.."
sudo sh ./menu.sh
fi





