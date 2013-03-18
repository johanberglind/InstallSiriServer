#InstallSiriServer

## REQUIREMENT
You need a C compiler installed! On most Linux Distros this comes out of the box.
On Mac OS X you can either install Xcode or install this:
https://github.com/kennethreitz/osx-gcc-installer

## MAC OS X USERS

If you want a much easier way of installing the SiriServer aswell as updating and configuring. We've just released
a Mac OSX app that simplifies everything and packages it with a neat GUI. Download it from the project page. Or on:

https://github.com/johanberglind/InstallSiriServer/raw/master/InstallSiri.dmg

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

