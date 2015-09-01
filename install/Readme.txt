@author: Bala

Installation steps are for working in a debian distro like Ubuntu.

1) First step is to install emacs
         $ sudo apt-add-repository ppa:ubuntu-elisp/ppa
         $ sudo apt-get install emacs-snapshot emacs-snapshot-el

2) Second step is to install scheme and we use MIT dialect of scheme
          $ sudo apt-get update && sudo apt-get install mit-scheme
   This should install the binary in /usr/bin and make sure you have your bash-profile $PATH configured to /usr/bin/
