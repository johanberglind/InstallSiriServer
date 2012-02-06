README - InstallSiriServer

REMEBER: EXPERIMENTAL CODE AT THE MOMENT

REQUIREMENT: You need a C compiler installed! On most Linux Distros this comes out of the box.
On Mac OSX you can either install Xcode or install this:
https://github.com/kennethreitz/osx-gcc-installer

Everything else the script handles. Good luck

First open the terminal and cd into the directory where you've downloaded
the script (In Debian and OSX you can do so by writing "cd " and then
drag the folder into the terminal.
To fix permissions for the script run:

chmod +x InstallSiriServer.sh
After that to start the script run:

sudo ./InstallSiriServer.sh

64-bit version (remove the parameter --disable-asm-optimizations if you're running 32-bit)

If you've already installed the server and dependencies and want to start it up
again, just go ahead an cd into the Eichhoernchen-server directory and type:

sudo python siriServer.py

Check out the Eichhoernchen project at:
https://github.com/Eichhoernchen/SiriServer
 
