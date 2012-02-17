#!/bin/bash

DIR=""

check_libogg () {
  # Checks for libogg package and if it's already installed scripts moves on to libspeex
  cd /tmp/
  echo "Checking Libogg"
  if [ -f /usr/local/lib/libogg.a ]; then 
    echo "Libogg is already installed, proceeding to next step"
  else 
    echo "Not installed, downloading libogg"
    cd /tmp/
    curl http://downloads.xiph.org/releases/ogg/libogg-1.3.0.zip > libogg-1.3.0.zip
    unzip libogg-1.3.0.zip
    cd libogg-1.3.0
    echo "Installing libogg"
    ./configure
    make
    sudo make install
    cd ..
    clear
  fi
}

check_libspeex () {
  # Checks for libspeex and if it's already installed the scripts moves on to checking for flac
  echo "Checking Libspeex"
  if [ -f /usr/local/lib/libspeex.a ]; then 
    echo "Libspeex is already installed, proceeding to next step"
  else 
    echo "Not installed, downloading Libspeex"
    cd /tmp/
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
    cd ..
  fi
  read -p "Press [ENTER] to continue"
  clear
}

check_flac () {
  # Checks for FLAC and if it's already installed the scripts moves on
  echo "Checking for Flac..."
  if [ "$(which flac)" != "" ]; then 
    echo "FLAC is already installed, proceeding to next step"
  else 
    cd /tmp/
    curl -L http://sourceforge.net/projects/flac/files/flac-src/flac-1.2.1-src/flac-1.2.1.tar.gz/download > flac-1.2.1.tar.gz
    clear
    echo "Download complete, unzipping"
    tar -xf flac-1.2.1.tar.gz
    clear
    echo "Installing Libflac..."
    cd flac-1.2.1
    ## Checking wether 64 or 32 bit system to use for flac compilation
    VERSION=`uname -a | grep "x86_64"`
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
}

check_Curl () {
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
}

check_Git () {
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
}

check_OpenSsl () {
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
}

check_Easy () {
  echo "Installing easy_install"
  if [ "$(which easy_install)" != "" ]; then 
    echo "easy_install is installed, proceeding"
  else 
    PYTHON=`(python -V 2>&1)`
    PYTHON=${PYTHON##* }
    PYTHON=${PYTHON%.*}
    echo "Using $PYTHON as your python version"
    echo "Downloading and installing easy_install"
    curl http://pypi.python.org/packages/$PYTHON/s/setuptools/setuptools-0.6c11-py$PYTHON.egg#md5=2baeac6e13d414a9d28e7ba5b5a596de > setuptools-0.6c11-py$PYTHON.egg
    sh setuptools-0.6c11-py$PYTHON.egg
    clear
  fi
}

check_biplist () {
    echo "Installing biplist"
    sudo easy_install biplist
    clear
}

check_M2Crypto () {
    echo "Installing M2Crypto"
    sudo easy_install M2Crypto
    clear
}

check_jsonrpclib () {
    echo "Installing jsonrpclib ... "
    sudo easy_install jsonrpclib
    wait
    clear
}

check_wordnik () {
    echo "Installing wordnik ... "
    sudo easy_install wordnik
    wait
    clear
}

clone () {
  if [ "$DIR" == "" ]; then 
    echo "Where would you like to install SiriServer?"
    echo -e "Note: you may only use absolute paths. eg.:'/Users/$(whoami)/siriServer/'"
    read NEW_DIR
    DIR=$NEW_DIR
  fi
  echo "Cloning SiriServer from Github... "
  sudo git clone git://github.com/Eichhoernchen/SiriServer.git $DIR
  clear
}

certificate () {
  if [ "$DIR" == "" ]; then 
    echo -e "Where is SiriServer installed?"
    echo -e "Note: you may only use absolute paths. eg.:'/Users/$(whoami)/siriServer/'"
    read NEW_DIR
    DIR=$NEW_DIR
  fi
  cd $DIR/gen_certs/
  clear
  IPGUESS=`ifconfig |grep "inet" |awk '{print $2}' | awk '/192*/ {print}'`
  echo "Time to generate SSL-certs, what is the IP of the Siriserver (this computer) [possibly $IPGUESS]?"
  read IP
  sudo ./gen_certs.sh $IP
  clear
  echo "Certificate generated, now you need to transfer the ca.pem file to your iOS device"
  echo "The easiest way is to email it to yourself and open it on your iOS device"
  echo "The settings page on Spire should now use this url: https://$IP"
  read -p "Press [ENTER] to continue"
  clear
}

startup_script () {
  if [ "$DIR" == "" ]; then 
    echo -e "Where is SiriServer installed?"
    echo -e "Note: you may only use absolute paths. eg.:'/Users/$(whoami)/siriServer/'"
    read NEW_DIR
    DIR=$NEW_DIR
  fi
  cd $DIR/startupScripts/
  echo "Copying script to /etc/init.d/siriserver"
  sudo sed -i.old "s/\/path\/to\/siriServer\/folder\//$(echo $DIR | sed -e 's/\//\\\//g')/" siriserver
  sudo mv siriserver /etc/init.d/siriserver
  sudo chmod a+x /etc/init.d/siriserver
  echo "Updating rc.d"
  sudo update-rc.d siriserver defaults
}

edit_conf () {
  if [ "$DIR" == "" ]; then 
    echo -e "Where is SiriServer installed?"
    echo -e "Note: you may only use absolute paths. eg.:'/Users/$(whoami)/siriServer/'"
    read NEW_DIR
    DIR=$NEW_DIR
  fi
  sudo nano $DIR/apiKeys.conf
}

update () {
  if [ "$DIR" == "" ]; then 
    echo -e "Where is SiriServer installed?"
    echo -e "Note: you may only use absolute paths. eg.:'/Users/$(whoami)/siriServer/'"
    read NEW_DIR
    DIR=$NEW_DIR
  fi
  cd $DIR
  PID=`ps -ef | awk '/[s]iriServer/ { print $2 }'`
  if [ "$PID" != "" ]; then 
    echo "Killing SiriServer..."
    sudo kill $PID
  fi
  echo "Updating ..."
  git pull
  clear
  echo "Update finished."
}

### PRESENT MENU ###
SiriServer_Menu (){
    
    clear
    echo "
  ###################################################################
  |   #####              #####                                      |
  |  #     # # #####  # #     # ###### #####  #    # ###### #####   |
  |  #       # #    # # #       #      #    # #    # #      #    #  |
  |   #####  # #    # #  #####  #####  #    # #    # #####  #    #  |
  |        # # #####  #       # #      #####  #    # #      #####   |
  |  #     # # #   #  # #     # #      #   #   #  #  #      #   #   |
  |   #####  # #    # #  #####  ###### #    #   ##   ###### #    #  |
  |                                                                 |
  ######### MAC OS X version ################## script by gugahoi ###
     
     "
  if [ "$DIR" != "" ]; then 
    echo "Current directory is \"$DIR\""
    echo 
  fi

    show_Menu () {

        echo "1. Install SiriServer"
        echo "2. Install plugin dependencies"
        echo "3. Update SiriServer (experimental)"
        echo "4. Generate certificates"
        echo "5. Edit API's"
        echo "6. Install startup script"
        echo 
        echo 
        echo "Q. Quit"

        read SELECT

        case "$SELECT" in

            # Install SiriServer
            1)
                check_Curl
                check_Git
                check_OpenSsl
                check_Easy
                check_libogg
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
                  clear
                fi
                clone
                echo -e "Would you like to put your API keys now? [y/n] "
                read answer
                if [ "$answer" == "y" ]; then 
                  edit_conf
                else
                  echo "This can be done later by editing the apiKeys.conf file in your siriServer folder"
                  read -p "Press [ENTER] to continue"
                  clear
                fi                
                certificate
                echo -e "Would you like to have SiriServer start on boot? [y/n] "
                read answer
                if [ "$answer" == "y" ]; then 
                  startup_script
                  START=1
                else
                  START=0
                fi
                echo "You are now finished installing, you should find your installation on $DIR"
                echo "To use your siriserver you can use the following command(s):"
                if [ "$START" -eq 1 ]; then
                  echo "sudo service siriserver start"
                  echo "sudo service siriserver stop"
                  echo "sudo service siriserver restart"
                else
                  echo "cd $DIR"
                  echo "sudo python siriServer.py"
                fi
                ;;
                
            # Install plugin dependencies
            2)
                check_wordnik
                check_jsonrpclib
                ;;

            # Update SiriServer
            3)
                update
                ;;

            # Generate certificate
            4)
                certificate
                ;;

            # Edit apiKeys.conf file
            5)
                edit_conf
                ;;

            6)
                startup_script
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