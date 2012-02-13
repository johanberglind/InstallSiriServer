#!/bin/bash

# Menu script for the InstallSiriServer aswell as an updater
# By johanberglind, it uses the update.sh script for updating from the
# Eichhoernchens Siriserver project

clear
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
echo "3. Exit"
tput sgr0
tput cup 10 15
tput setaf 1
tput bold
read -p "Enter your choice (1-3): " CHOICE
if [ $CHOICE -eq 1 ]
then sudo sh ./InstallSiriServer.sh
fi
if [ $CHOICE -eq 2 ]
then echo Updating...
clear
cd serverfolder
cd Eich*
sudo sh ./updateServer.sh
echo "Update complete, all files are up to date!"
fi
if [ $CHOICE -eq 3 ]
then echo "Goodbye!" && exit
fi





