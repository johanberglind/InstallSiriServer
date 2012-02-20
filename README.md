#InstallSiriServer

## REQUIREMENT
You need a C compiler installed! On most Linux Distros this comes out of the box.
On Mac OS X you can either install Xcode or install this:
https://github.com/kennethreitz/osx-gcc-installer

Everything else the script handles. Good luck

## INSTRUCTIONS

First open the terminal and cd into the directory where you've downloaded
the script (In Debian and OS X you can do so by writing "cd " and then
drag the folder into the terminal.

To make the script executable and run:

### On Mac's

    chmod +x MAC.InstallSiriServer.sh
    sudo ./MAC.InstallSiriServer.sh

### On Debian/*Buntu based systems

    chmod +x Ubuntu.InstallSiriServer.sh
    sudo ./Ubuntu.InstallSiriServer.sh

If you've already installed the server and dependencies and want to start it up
again, just go ahead an cd into the siriServer directory and type:

    sudo python siriServer.py

Check out the Eichhoernchen project at:
https://github.com/Eichhoernchen/SiriServer
 
Video walkthrough:
http://www.youtube.com/watch?v=ZzkJEGsyj-A

## CREDIT

A lot of the script was originally written by @johanberglind and some logic borrowed from the LaSi script by @Mar2zz. Without them these would not exist.
