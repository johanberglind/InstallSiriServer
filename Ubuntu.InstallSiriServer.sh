#!/bin/bash

$DIR = ""

check_Git () {
    echo "Checking git"
    if ! which git > /dev/null; then
        echo "Installing git"
        sudo apt-get -y install git
        clear
    else
        echo "Git already installed"
    fi
}

check_Easy () {
    echo "Checking easy_install"
    if ! which easy_install > /dev/null; then
        echo "Installing easy_install"
        sudo apt-get -y install python-setuptools
        clear
    else
        echo "easy_install already installed"
    fi
}

check_libspeex () {
  echo "Checking Libspeex"
  if [ "$(locate libspeex)" != "" ]; then 
    echo "Libspeex is already installed, proceeding to next step"
  else 
    echo "Installing Libspeex"
    sudo apt-get -y install libspeex1 
    clear
  fi
}

check_flac () {
  echo "Checking Flac"
  if [ "$(locate flac)" != "" ]; then 
    echo "FLAC is already installed, proceeding to next step"
  else 
    echo "Installing flac"
    sudo apt-get -y install libflac8 
    clear
  fi
}

check_biplist () {
  echo "Checking biplist"
  if [ "$(locate biplist)" != "" ]; then 
    echo "biplist is already installed, proceeding to next step"
  else 
    echo "Installing biplist"
    sudo easy_install biplist
    clear
  fi
}
check_M2Crypto () {
  echo "Checking M2Crypto"
  if [ "$(locate M2Crypto)" != "" ]; then 
    echo "M2Crypto is already installed, proceeding to next step"
  else 
    echo "Installing M2Crypto"
    sudo apt-get install python-M2Crypto
    clear
  fi
}

check_jsonrpclib () {
  echo "Checking jsonrpclib"
  if [ "$(locate jsonrpclib)" != "" ]; then 
    echo "jsonrpclib is already installed, proceeding to next step"
  else 
    echo "Installing jsonrpclib ... "
    sudo easy_install jsonrpclib
    clear
  fi
}

check_wordnik () {
  echo "Checking wordnik"
  if [ "$(locate wordnik)" != "" ]; then 
    echo "wordnik is already installed, proceeding to next step"
  else 
    echo "Installing wordnik ... "
    sudo easy_install wordnik
    clear
  fi
}

clone () {
  if [ $DIR = "" ]; then 
    echo -e "Where would you like to install SiriServer? (eg.: '/home/')"
    read NEW_DIR
    $DIR = $NEW_DIR
  fi
  echo "Cloning SiriServer from Github... "
  git clone git://github.com/Eichhoernchen/SiriServer.git $DIR
  clear
}

certificate () {
  if [ $DIR = "" ]; then 
    echo -e "Where is SiriServer installed? (eg.: '/opt/SiriServer/')"
    read NEW_DIR
    $DIR = $NEW_DIR
  fi
  cd gen_certs/
  clear
  $IPGUESS = `ifconfig |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
  echo "Time to generate SSL-certs, what is the IP of the Siriserver (this computer) [possibly $IPGUESS]? [----------90%]"
  read IP
  sudo ./gen_certs.sh $IP
  clear
  echo "Certificate generated, now you need to transfer the ca.pem file to your iOS device"
  echo "The easiest way is to email it to yourself and open it on your iOS device"
  echo "The settings page on Spire should now use this url: https://$IP"
  read -p "Press [ENTER] to continue to the next step when you've installed it"
  clear
}

pid () {
  PID = `ps -ef | awk '/siriServer/ { print $2 }'`
  echo PID
}

### PRESENT MENU ###
SiriServer_Menu (){
    
    clear
    echo "
     #####              #####                                     
    #     # # #####  # #     # ###### #####  #    # ###### #####  
    #       # #    # # #       #      #    # #    # #      #    # 
     #####  # #    # #  #####  #####  #    # #    # #####  #    # 
          # # #####  #       # #      #####  #    # #      #####  
    #     # # #   #  # #     # #      #   #   #  #  #      #   #  
     #####  # #    # #  #####  ###### #    #   ##   ###### #    # 
     
     "

    show_Menu () {

        echo "1. Install SiriServer"
        echo "2. Install plugin dependencies"
        echo "3. Update SiriServer"
        echo "4. Generate certificates"
        echo 
        echo 
        echo "Q. Quit"

        read SELECT

        case "$SELECT" in

            # Install SiriServer
            1)
                check_Git
                check_Easy
                check_libspeex
                check_flac
                check_biplist
                check_M2Crypto
                echo -e "Would you like to install all the plugin dependencies? [y/n] "
                read answer
                if [ "$answer" == "y" ]; then 
                  check_wordnik
                  check_jsonrpclib
                else
                  echo "Note that when not installing those dependencies, some plugins might not work as expected"
                  read -p "Press [ENTER] to continue"
                fi
                clear
                clone
                certificate
                ;;
                
            # Install plugin dependencies
            2)
                check_wordnik
                check_jsonrpclib
                ;;

            # Update SiriServer
            3)
                pid
                ;;

            # Generate certificate
            4)
                certificate
                ;;

            [Qq]) exit ;;

            *)
                echo "Please make a selection (e.g. 1)"
                show_Menu
                ;;
        esac

    # give time to read output from above installprocess before returning to menu
    echo 
    read -sn 1 -p "Press a key to continue"
    SiriServer_Menu
    }
    show_Menu
}

SiriServer_Menu
